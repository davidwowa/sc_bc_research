import qrcode
import qrcode.image.svg
import sys

def build_qr_from(data):
    factory = qrcode.image.svg.SvgImage
    print("create qr image for " + data)
    img = qrcode.make(data, image_factory=factory)
    print("save qr image as " + data + ".svg")
    img.save(data + ".svg")
build_qr_from(sys.argv[1])