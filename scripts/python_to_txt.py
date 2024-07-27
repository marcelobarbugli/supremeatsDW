import dash
import dash_core_components as dcc
import dash_html_components as html
from dash.dependencies import Input, Output
import pandas as pd
from datetime import datetime

# Obter o timestamp atual com ano e mês
timestamp = datetime.now().strftime('%Y-%m')

df = pd.read_csv('view_SalesSummary.csv')

app = dash.Dash(__name__)

app.layout = html.Div([
    html.H1(f'Cliente que mais gastou no mês de: {timestamp}', className='header-title'),
    dcc.Graph(
        id='exemplo-grafico',
        figure={
            'data': [
                {'x': df['Cliente'], 'y': df['TotalVendas'], 'type': 'bar', 'name': 'Dados'}
            ],
            'layout': {
                'title': 'Gráfico de Exemplo'
            }
        }
    )
], className='main-container')

if __name__ == '__main__':
    app.run_server(debug=True)
