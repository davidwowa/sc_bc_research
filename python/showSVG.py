import sys
from PyQt5.QtWidgets import QApplication
from PyQt5.QtSvg import QSvgWidget

from io import BytesIO
import matplotlib.pyplot as plt
# from https://gist.github.com/gmarull/dcc8218385014559c1ca46047457c364
# matplotlib: force computer modern font set
plt.rc('mathtext', fontset='cm')

def tex2svg(formula, fontsize=12, dpi=300):
    """Render TeX formula to SVG.
    Args:
        formula (str): TeX formula.
        fontsize (int, optional): Font size.
        dpi (int, optional): DPI.
    Returns:
        str: SVG render.
    """

    fig = plt.figure(figsize=(0.01, 0.01))
    fig.text(0, 0, r'${}$'.format(formula), fontsize=fontsize)

    output = BytesIO()
    fig.savefig(output, dpi=dpi, transparent=True, format='svg',
                bbox_inches='tight', pad_inches=0.0, frameon=False)
    plt.close(fig)

    output.seek(0)
    return output.read()

def main():
    FORMULA = r'\int_{-\infty}^\infty e^{-x^2}\,dx = \sqrt{\pi}'

    app = QApplication(sys.argv)

    svg = QSvgWidget()
    svg.load(tex2svg(FORMULA))
    svg.show()

    sys.exit(app.exec_())

if __name__ == '__main__':
    main()