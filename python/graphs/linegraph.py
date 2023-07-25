import plotly.express as px
from src.styler import BaseStyle


basestyle = BaseStyle()


def line(data, x, y, color: None, width=750, height=490, **kwargs):
    fig = px.line(
        data_frame=data,
        x=x,
        y=y,
        color=color,
        width=width,
        height=height,
        template=BaseStyle().get_base_template(),
        **kwargs
    )

    return fig
