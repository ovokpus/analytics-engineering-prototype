"""Plotly charts on the cream trading-desk background."""

from __future__ import annotations

import pandas as pd
import plotly.express as px
import plotly.graph_objects as go

INK = "#1C1917"
GREEN = "#1F6B4A"
GOLD = "#A6843D"
TERRACOTTA = "#8C4A2F"
NAVY = "#2F4A6B"


def style(fig: go.Figure) -> go.Figure:
    fig.update_layout(
        paper_bgcolor="rgba(0,0,0,0)",
        plot_bgcolor="rgba(0,0,0,0)",
        font_color=INK,
        title_font_color=INK,
        legend_font_color=INK,
        margin=dict(l=8, r=8, t=48, b=8),
        height=360,
        colorway=[GREEN, GOLD, TERRACOTTA, NAVY, "#6B3A4A"],
    )
    fig.update_xaxes(color=INK, gridcolor="#E4DDD0", zerolinecolor="#E4DDD0")
    fig.update_yaxes(color=INK, gridcolor="#E4DDD0", zerolinecolor="#E4DDD0")
    return fig


def bar(
    frame: pd.DataFrame,
    x: str,
    y: str,
    title: str,
    *,
    horizontal: bool = False,
    labels: dict[str, str] | None = None,
) -> go.Figure:
    if horizontal:
        fig = px.bar(frame, x=y, y=x, orientation="h", title=title, labels=labels)
    else:
        fig = px.bar(frame, x=x, y=y, title=title, labels=labels)
    fig.update_traces(marker_color=GREEN)
    return style(fig)


def line(
    frame: pd.DataFrame,
    x: str,
    y: str,
    title: str,
    *,
    labels: dict[str, str] | None = None,
) -> go.Figure:
    fig = px.line(frame, x=x, y=y, title=title, markers=True, labels=labels)
    fig.update_traces(line_color=GREEN)
    return style(fig)


def stacked_bar(
    frame: pd.DataFrame,
    x: str,
    y: str,
    color: str,
    title: str,
    *,
    labels: dict[str, str] | None = None,
) -> go.Figure:
    fig = px.bar(frame, x=x, y=y, color=color, title=title, labels=labels)
    return style(fig)
