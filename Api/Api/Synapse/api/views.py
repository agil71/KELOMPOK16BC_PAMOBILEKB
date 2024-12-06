import json
import joblib
import numpy as np
import os
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt

# Memuat model
model_path = os.path.join(os.path.dirname(__file__), 'model/garden/model.joblib')
try:
    model = joblib.load(model_path)
except Exception as e:
    model = None
    print(f"Error loading model from {model_path}: {e}")

@csrf_exempt
def predict(request):
    if request.method == 'POST':
        try:
            # Memastikan model berhasil dimuat
            if model is None:
                return JsonResponse({'error': 'Model not loaded properly'}, status=500)
            
            # Membaca input JSON
            data = json.loads(request.body.decode('utf-8'))
            user_data = data.get('data')

            if user_data is None:
                return JsonResponse({'error': 'No data provided'}, status=400)

            # Debug: Periksa panjang input data
            print(f"Length of user data: {len(user_data)}")  # Menambahkan debug

            # Konversi data ke format numpy array
            user_data_array = np.array(user_data).reshape(1, -1)

            expected_features = model.n_features_in_

            if user_data_array.shape[1] != expected_features:
                return JsonResponse({'error': f'Invalid input shape. Expected {expected_features} features, but got {user_data_array.shape[1]}.'}, status=400)

            # Prediksi
            prediction = model.predict(user_data_array)

            return JsonResponse({'message': 'Data received', 'prediction': prediction.tolist()}, status=200)
        except json.JSONDecodeError:
            return JsonResponse({'error': 'Invalid JSON format'}, status=400)
        except Exception as e:
            from django.conf import settings
            if settings.DEBUG:
                return JsonResponse({'error': f'Internal Server Error: {str(e)}'}, status=500)
            else:
                return JsonResponse({'error': 'Internal Server Error'}, status=500)
    else:
        return JsonResponse({'error': 'This endpoint only supports POST requests.'}, status=405)


