# O Valente — Projeto Vamos à Arca (Radical Dev)

Jogo infantil 2D em **Godot 4.2+** (GDScript). Interface, cenário, inimigos e sons são feitos por código; o Valente usa sprites PNG (em `assets/valente/frames/`) montados em SpriteFrames **por código**.

## Como abrir
1. Abre o Godot e, no Gestor de Projetos, clica em **Importar**.
2. Escolhe o ficheiro `project.godot` desta pasta e abre.
3. Espera a importação terminar e carrega em **F5** (Executar Projeto).

> Se o Godot perguntar sobre converter o projeto ou mostrar um aviso de versão, aceita. Funciona em qualquer 4.2 ou superior.

## Controlos (para testar no PC)
| Ação | Teclas |
|---|---|
| Andar | Setas ← → ou A / D |
| Saltar | Espaço, W ou ↑ |
| Escudo (depois de o apanhar) | J, X ou K |

No telemóvel há botões no ecrã (os botões também respondem ao rato no PC).

## Sprites do Valente (novo)
Os PNG que enviaram foram recortados frame a frame, alinhados pelos pés e normalizados (todos 304x272), para a troca de animação não "saltar".
`gameplay/valente_frames.gd` monta o SpriteFrames em código; para mudar velocidade ou frames de uma animação, editem só as linhas `_add(...)` desse ficheiro.

| Animação | Origem | Quando toca |
|---|---|---|
| `idle` | idle.png | parado |
| `run` | runing.png (8 frames) | a andar |
| `jump_rise` / `jump_apex` / `jump_fall` / `land` | jump.png | a subir / no topo / a cair / ao aterrar |
| `celebrate` | celeb.png (8 frames) | quando vence o boss |
| `shield_equip` / `shield_guard` | **novos** (feitos a partir do idle) | ao apanhar o Escudo da Fé / enquanto segura ESCUDO |

As animações do escudo foram montadas sobre o sprite idle (escudo desenhado com a armadura azul e dourada e uma cruz). O Valente não muda de pose com o braço. Quando quiserem a pose real, gerem 8 frames no vosso gerador com o idle como referência e substituam os ficheiros `shield_equip_0..7.png` e `shield_guard_0..1.png`, mantendo o tamanho 304x272 e os pés na mesma linha.

## Estado atual (Sprint 1)
- Splash, Menu, Seleção de Níveis, Definições (som e idioma), FAQ e Armadura.
- **Nível 1 jogável**: Fase 1 sem escudo, Escudo da Fé, Fase 2, e boss Gigante da Sombra (8 de vida).
- Gravação de progresso (níveis desbloqueados e armadura).
- Os níveis 2 e 3 já aparecem no ecrã de seleção, mas ainda mostram «Em breve».

## Mapa dos ficheiros
```
main.gd / main.tscn      gestor de ecrãs (único nó da cena principal)
autoload/                game_state.gd (progresso e definições), sfx.gd (sons gerados por código)
core/                    art.gd (todos os desenhos), ui_kit.gd, screen.gd, forest_background.gd
data/                    bible.gd (versículos e armadura), faq_data.gd, strings.gd (PT/EN)
screens/                 splash, menu, level_select, settings, faq, armor
gameplay/                valente, minion, boss, projectile, pickup, hud, touch_visual
levels/level_1.gd        o Nível 1
assets/valente/frames/   frames PNG do Valente (idle, run, jump, celeb, shield)
```

## Onde mexer para ajustar a dificuldade
No topo de `levels/level_1.gd`, o bloco **AJUSTES**: vida do jogador, vida do boss, intervalo e velocidade das chamas, tempo de aviso do boss.

## Como acrescentar um nível novo
1. Copiar `levels/level_1.gd` para `level_2.gd` e mudar o boss, os inimigos e o mapa.
2. Registar `"level_2"` em `main.gd` (lista SCREENS).
3. Juntar o `2` a `IMPLEMENTED` em `screens/level_select.gd`.

## Limitações conhecidas
- O texto em inglês só cobre os menus; a FAQ e os níveis estão só em português.
- Ainda sem música; os efeitos sonoros são simples e gerados por código.
- O código não foi executado no Godot antes da entrega: se aparecer algum erro, copiem a mensagem completa do painel **Saída** ou **Depurador**.
