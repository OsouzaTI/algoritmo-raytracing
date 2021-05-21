using Images
include("vector/vector.jl")
include("ray/ray.jl")
include("primitives/sphere.jl")

# constantes
aspectratio = 16 / 9
imgWidth = 800
imgHeight = trunc(Int64, imgWidth/aspectratio)
imgData = RGB.(zeros(imgHeight, imgWidth))

# câmera
viewportheight  = 2.0
viewportwidth   = viewportheight * aspectratio
horizontal      = vec3(viewportwidth, 0.0, 0.0)
vertical        = vec3(0.0, viewportheight, 0.0)
focallenght     = 1.0
origin          = VEC3_NULO
lowerleftcorner = origin - horizontal/2 - vertical/2 - vec3(0.0, 0.0, focallenght)

println("Imagem properties: ")
println("\tsize(", imgWidth ,", ", imgHeight,")")
println("\tviewportwidth(",viewportwidth,")")
println("\tviewportheight(",viewportheight,")")
println("\torigin(",origin,")")
println("\tvertical(", vertical,")")
println("\thorizontal(",horizontal,")")
println("\tfocal lenght(",focallenght,")")
println("\tlower left corner(",lowerleftcorner,")")

sphere = Sphere(vec3(0.0, 0.0, -1.0), 0.5)

for j = 1:imgHeight
    for i = 1:imgWidth
                
        u = (i - 1) / (imgWidth - 1)
        v = 1.0 - (j - 1) / (imgHeight - 1)
        dir = lowerleftcorner + u * horizontal + v * vertical - origin
        ray = Ray(origin, dir)
        imgData[j, i] = raycolor(ray, sphere)

    end
end


save("rendered/image2.png", imgData)

