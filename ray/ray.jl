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

u = vec3(1.0, 2.0, 3.0)
v = vec3(7.0, 0.0, 0.0)
r = Ray(u, v)