using Images

imgWidth = 640
imgHeight = 480

imgData = RGB.(zeros(imgHeight, imgWidth))

for j = 1:imgHeight
    for i = 1:imgWidth
        
        r = (i - 1) / (imgWidth - 1)
        g = 1.0 - (j - 1) / (imgHeight - 1)
        b = 0.25
        
        imgData[j, i] = RGB(r, g, b)

    end
end


save("rendered/image0.png", imgData)

