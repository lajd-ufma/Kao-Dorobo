shader_type canvas_item;

uniform float circle_size : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    // Calcula a distância do centro da UV
    float dist = distance(UV, vec2(0.5));
    
    // Pega a cor original da textura
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Cria o círculo: 1.0 se dentro do raio, 0.0 se fora
    float mask = 1.0 - step(circle_size, dist);
    
    // Aplica a máscara no canal Alpha
    COLOR.rgb = tex_color.rgb;
    COLOR.a = tex_color.a * mask;
}
