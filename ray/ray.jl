include("../vector/vector.jl")
include("../primitives/sphere.jl")

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

function rayAt(ray::Ray, t::Real)
    # retorna o vetor do raio em função 
    # de um valor arbitrário 't'
    ray.origin + t * ray.direction
end

function backgroundColor(direction)
    # é sabido que a câmera varia dentre -1 a 1
    # então ao somar 1 em y, a variação ocorrerá
    # entre 0 a 2. Basta multiuplicar 1/2 e obteremos 
    # nosso parâmetro 't' da combinação convexa
    t = 0.5 * (direction[2] + 1.0)
    (1-t)RGB(1.0, 1.0, 1.0) + t * RGB(0.5, 0.7, 1.0)
end

function raycolor(ray::Ray, sphere::Sphere)
    t = hitSphere(sphere, ray) 
    if t > 0
        # ponto de intersecção do raio na esfera
        intersectPoint = rayAt(ray, t)
        # normal da esfera nesse ponto de intersecção
        normal = normalize(intersectPoint - sphere.center)
        # cor a partir da normal
        ncolor = 0.5 * (normal .+ 1.0)
        
        RGB(ncolor...)

    else
        backgroundColor(ray.direction)
    end
end

### Hit objects

function hitSphere(sphere::Sphere, ray::Ray)
    # a  = normasquare(ray.direction)
    # OC = sphere.center - ray.origin
    # b  = 2.0 * dot(ray.direction, OC)
    # c  = normasquare(OC) - sphere.radius^2 
    a  = normasquare(ray.direction)
    OC = ray.origin - sphere.center
    halfb  = dot(ray.direction, OC)
    c  = normasquare(OC) - sphere.radius^2 

    delta = (halfb * halfb) - a * c

    if delta < 0 
        -1.0
    else        
        # t = (-halfb - √delta / a)
        (-halfb - √delta / a)
    end
end


# u = vec3(1.0, 2.0, 3.0)
# v = vec3(7.0, 0.0, 0.0)
# r = Ray(u, v)