from pathlib import Path
from decouple import config # Adicione esta linha

# Substitua os valores manuais pelo config('NOME_DA_VARIAVEL')
SECRET_KEY = config('SECRET_KEY')

DEBUG = config('DEBUG', default=False, cast=bool)

# Exemplo para o Banco de Dados
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / config('DB_NAME', default='db.sqlite3'),
    }
}