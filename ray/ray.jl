import Base.*

include("../vector/vector.jl")
include("../primitives/sphere.jl")
include("../colors/colors.jl")
include("../scene/scene.jl")

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
    # (1-t)RGB(0.7, 0.8, 0.9) + t * RGB(0.05, 0.0, 0.2)
    # (1-t)MARS + t * RGB(0.2, 0.0, 0.05)
    (1-t)RGB(1.0, 1.0, 1.0) + t * RGB(0.5, 0.7, 1.0)
end

function raycolor(ray::Ray, scenelist::SceneList, depth::Int)
    record = HitRecord()

    if depth ≤ 0
        return RGB(0.0, 0.0, 0.0)
    end

    if hitSphere!(scenelist, ray, 0.0001, Inf, record)
        shouldscatter, attenuation, direction = scatter(record.material, ray, record)
        if shouldscatter
            raio = Ray(record.intersectPoint, direction)
            return attenuation * raycolor(raio, scenelist, depth-1)
        else
            return RGB(0.0, 0.0, 0.0)
        end

    end

    # origin = ray.origin
    # direction = ray.direction
    # while hitSphere!(scenelist, Ray(origin, direction), 0.0001, Inf, record) 
    #     direction = normalize(reflect(direction, record.normal))
    #     origin = record.intersectPoint
    #     # # cor a partir da normal
    #     # ncolor = 0.5 * (record.normal .+ 1.0)        
    #     # RGB(ncolor...)
    # end
    backgroundColor(ray.direction)
end

### Hit objects

function hitSphere!(sphere::Sphere, ray::Ray, tmin, tmax, record::HitRecord)
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
        false
    else        
        # t = (-halfb - √delta / a)
        # (-halfb - √delta / a)        
        t = (-halfb - √delta) / a
        if t < tmin || t > tmax
            t = (-halfb + √delta) / a
            if t < tmin || t > tmax
                return false
            end
        end
        record.t = t
        # ponto de intersecção do raio na esfera
        record.intersectPoint = rayAt(ray, t)  
        # normal da esfera nesse ponto de intersecção              
        outward_normal = normalize(record.intersectPoint - sphere.center)
        # orientação da face onde o raio bateu
        record.frontFace = dot(ray.direction, outward_normal) < 0
        # detectando a normal da face
        if record.frontFace
            record.normal = outward_normal
        else
            record.normal = -outward_normal
        end
        record.material = sphere.material
        true
    end
end

function hitSphere!(scenelist::SceneList, ray::Ray, tmin, tmax, record::HitRecord)
    hitanything = false
    auxRecord = HitRecord()
    closestofar = tmax

    for object in scenelist.objects
        if hitSphere!(object, ray, tmin, closestofar, auxRecord)
            hitanything = true
            closestofar = auxRecord.t

            record.intersectPoint = auxRecord.intersectPoint
            record.t = auxRecord.t
            record.normal = auxRecord.normal
            record.frontFace = auxRecord.frontFace
            record.material = auxRecord.material
        end            
    end
    hitanything
end

# função de reflexão de um raio
function reflect(direction::vec3, normal::vec3)
    direction - 2 * dot(direction, normal) * normal;
end

function *(a::RGB, b::RGB)
    RGB(a.r * b.r, a.g * b.g, a.b * b.b)
end


# Espalhamento dos materiais

function scatter(material::Metal, ray::Ray, record::HitRecord)
    direction = reflect(ray.direction, record.normal)    
    # caso maior que 0, então os vetores estarão 
    # apontando na mesma direção
    shouldscatter = dot(direction, record.normal) > 0
    shouldscatter, material.albedo, direction
end

function randomUV()
    θ = rand(0.0:0.001:2*π)
    ϕ = rand(0.0:0.001:π)
    vec3(cos(θ)*sin(ϕ), sin(θ)*sin(ϕ), cos(ϕ))
end

function scatter(material::Lambertian, ray::Ray, record::HitRecord)

    scatterDirection = record.normal + randomUV()    
    if all(map(x -> isapprox(x, 0, atol = 1e-8), scatterDirection))
        scatterDirection = record.normal
    end

    true, material.albedo, scatterDirection
end




# u = vec3(1.0, 2.0, 3.0)
# v = vec3(7.0, 0.0, 0.0)
# r = Ray(u, v)