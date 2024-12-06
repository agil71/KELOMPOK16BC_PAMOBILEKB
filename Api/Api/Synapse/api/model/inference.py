import numpy as np
import pandas as pd
import pickle
import joblib
import tensorflow as tf
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import StandardScaler, MinMaxScaler
from sklearn.compose import ColumnTransformer
from PIL import Image


class Model:
    def __init__(self, model_path):
        """
        Initialize the model based on the file extension.
        Supports .pkl, .joblib, .h5, and .tflite models.
        """
        if model_path.endswith('.pkl'):
            with open(model_path, 'rb') as f:
                self.model = pickle.load(f)
            self.model_type = 'sklearn'
        elif model_path.endswith('.joblib'):
            self.model = joblib.load(model_path)
            self.model_type = 'sklearn'
        elif model_path.endswith('.h5'):
            self.model = tf.keras.models.load_model(model_path)
            self.model_type = 'keras'
        elif model_path.endswith('.tflite'):
            self.model = tf.lite.Interpreter(model_path=model_path)
            self.model.allocate_tensors()
            self.model_type = 'tflite'
        else:
            raise ValueError(f"Unsupported model format '{model_path.split('.')[-1]}'. Use .pkl, .joblib, .h5, or .tflite.")

    def data_pipeline(self, numerical_features=None, scaler_type="standard"):
        """
        Create a preprocessing pipeline for numerical data.
        This method is only applicable for scikit-learn models.
        """
        if self.model_type != 'sklearn':
            raise ValueError("Data pipeline is only supported for scikit-learn models.")

        transformers = []

        if numerical_features:
            if scaler_type == "standard":
                transformers.append(('scaler', StandardScaler(), numerical_features))
            elif scaler_type == "minmax":
                transformers.append(('scaler', MinMaxScaler(), numerical_features))
            else:
                raise ValueError(f"Unsupported scaler type: '{scaler_type}'. Use 'standard' or 'minmax'.")

        preprocessor = ColumnTransformer(transformers, remainder='passthrough')

        pipeline = Pipeline([
            ('preprocessor', preprocessor),
            ('model', self.model)
        ])

        return pipeline

  

    def predict_from_data(self, data, numerical_features=None):
        """
        Predict from tabular data.
        Supported formats: list, numpy array, or pandas DataFrame.
        """
        if self.model_type == 'sklearn':
            # Convert data to DataFrame if it's a list or numpy array
            if isinstance(data, (list, np.ndarray)):
                data = pd.DataFrame([data])

            elif not isinstance(data, pd.DataFrame):
                raise ValueError("Data format not supported for sklearn model. Use list, NumPy array, or DataFrame.")

            # Perform prediction
            prediction = self.model.predict(data)

            # Example label conversion for a specific dataset (e.g., Iris dataset)
            prediction = "setosa" if prediction == 0 else "versicolor" if prediction == 1 else "virginica"

            return prediction

        elif self.model_type == 'keras':
            data = np.array(data)
            if data.ndim == 1:
                data = data.reshape(1, -1)
            prediction = self.model.predict(data)
            return prediction.tolist()

        elif self.model_type == 'tflite':
            input_details = self.model.get_input_details()
            output_details = self.model.get_output_details()

            data = np.array(data, dtype=input_details[0]['dtype'])
            if data.ndim == 1:
                data = np.expand_dims(data, axis=0)

            self.model.set_tensor(input_details[0]['index'], data)
            self.model.invoke()
            prediction = self.model.get_tensor(output_details[0]['index'])
            return np.argmax(prediction, axis=1).tolist()

        else:
            raise ValueError("Model type not supported.")

    @staticmethod
    def from_path(model_path):
        """
        Factory method to load the model from a file path.
        """
        return Model(model_path)
