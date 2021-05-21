include("../vector/vector.jl")
struct Ray{T <: AbstractFloat}

    origin::vec3{T}
    direction::vec3{T}

    function Ray{T}(ori::vec3{T}, dir::vec3{T}) where T
        new(ori, normalize(dir))
    end

end

# construtor de conveniência, não é necessário
# passar o tipo da estrutura, será implicito aos
# elementos (obrigatório serem do mesmo tipo).
function Ray(ori::vec3{T}, dir::vec3{T}) where T
    Ray{T}(ori, dir)
end

function raycolor(ray::Ray)
    # é sabido que a câmera varia dentre -1 a 1
    # então ao somar 1 em y, a variação ocorrerá
    # entre 0 a 2. Basta multiuplicar 1/2 e obteremos 
    # nosso parâmetro 't' da combinação convexa
    t = 0.5 * (ray.direction[2] + 1.0)
    (1-t)RGB(1.0, 1.0, 1.0) + t * RGB(0.5, 0.7, 1.0) 
end


# u = vec3(1.0, 2.0, 3.0)
# v = vec3(7.0, 0.0, 0.0)
# r = Ray(u, v)