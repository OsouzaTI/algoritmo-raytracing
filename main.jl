using Images

imgWidth = 640
imgHeight = 480

imgData = RGB.(zeros(imgHeight, imgWidth))

# iteração ocorrerá de 1 até o maximo número
# de linhas
for j = 1:imgHeight
# a cada mudança de 'j' o 'i' sofrerá uma alteração 
# completa, ou seja, será renderizado de cima para baixo
# e da esquerda para a direita
    for i = 1:imgWidth
        
        # o 'r' inicializará com 0 enquanto o denominador
        # será o máximo de colunas menos 1

        # iteração 1:
            # (1 - 1)/(640-1) -> 0/639 -> 0
        # iteração n
            # (640 - 1)/(640 - 1) -> 1

        # ou seja, a variação que ocorre está 
        # no intervalo de [0, 1]

        r = (i - 1) / (imgWidth - 1)
        g = 1.0 - (j - 1) / (imgHeight - 1)
        b = 0.25
        
        imgData[j, i] = RGB(r, g, b)

    end
end


save("rendered/image0.png", imgData)

