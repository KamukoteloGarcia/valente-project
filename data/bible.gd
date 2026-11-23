class_name Bible
extends RefCounted
## Conteúdo bíblico do jogo (versículos, níveis, peças da armadura).
## Os textos seguem a linha da Almeida; confirmem na versão usada pelo projeto antes de publicar.

const LEVELS := [
	{
		"id": 1, "name": "Vencer o Medo", "place": "A Floresta Escura",
		"ref": "Josué 1:9",
		"text": "Sê forte e corajoso; não temas, nem te espantes, porque o Senhor, teu Deus, é contigo, por onde quer que andares.",
		"boss": "Gigante da Sombra", "reward": "escudo",
	},
	{
		"id": 2, "name": "Vencer o Roubo", "place": "O Bairro Medieval",
		"ref": "Êxodo 20:15",
		"text": "Não furtarás.",
		"boss": "Rei Ladrão", "reward": "couraca",
	},
	{
		"id": 3, "name": "Vencer a Mentira", "place": "As Montanhas",
		"ref": "Efésios 4:25",
		"text": "Deixai a mentira e falai a verdade cada um com o seu próximo.",
		"boss": "Serpente Mentirosa", "reward": "cinto",
	},
]

## Peças da Armadura de Deus (Efésios 6:10-18). "level" = nível que dá a peça (0 = ainda por definir).
const ARMOR := [
	{"id": "escudo", "name": "Escudo da Fé", "ref": "Efésios 6:16", "level": 1,
	 "text": "Tomai sobretudo o escudo da fé, com o qual podereis apagar todos os dardos inflamados do Maligno."},
	{"id": "couraca", "name": "Couraça da Justiça", "ref": "Efésios 6:14", "level": 2,
	 "text": "Estai firmes, vestida a couraça da justiça."},
	{"id": "cinto", "name": "Cinto da Verdade", "ref": "Efésios 6:14", "level": 3,
	 "text": "Estai firmes, tendo cingidos os vossos lombos com a verdade."},
	{"id": "sandalias", "name": "Sandálias da Paz", "ref": "Efésios 6:15", "level": 0,
	 "text": "Calçados os pés na preparação do evangelho da paz."},
	{"id": "capacete", "name": "Capacete da Salvação", "ref": "Efésios 6:17", "level": 0,
	 "text": "Tomai o capacete da salvação."},
	{"id": "espada", "name": "Espada do Espírito", "ref": "Efésios 6:17", "level": 0,
	 "text": "A espada do Espírito, que é a palavra de Deus."},
]
