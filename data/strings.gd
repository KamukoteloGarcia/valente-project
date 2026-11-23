class_name Strings
extends RefCounted
## Textos da interface em Português (pt) e Inglês (en).
## Se faltar uma chave em "en", usa-se o texto em "pt".

const DATA := {
	"pt": {
		"tagline": "Vence o medo com a armadura de Deus",
		"play": "JOGAR",
		"armor": "ARMADURA",
		"settings": "DEFINIÇÕES",
		"faq": "FAQ",
		"back": "VOLTAR",
		"sound": "Som",
		"language": "Idioma",
		"lang_name": "Português",
		"on": "LIGADO",
		"off": "DESLIGADO",
		"reset": "Apagar progresso",
		"reset_confirm": "Tens a certeza? Toca de novo",
		"select_level": "Escolhe o nível",
		"level": "NÍVEL",
		"locked": "BLOQUEADO",
		"soon": "EM BREVE",
		"soon_toast": "Este nível chega numa próxima Sprint!",
		"armor_title": "A Armadura de Deus",
		"armor_locked": "Vence o nível %d",
		"armor_future": "Em breve",
		"faq_title": "Perguntas e Respostas",
	},
	"en": {
		"tagline": "Defeat fear with the armor of God",
		"play": "PLAY",
		"armor": "ARMOR",
		"settings": "SETTINGS",
		"faq": "FAQ",
		"back": "BACK",
		"sound": "Sound",
		"language": "Language",
		"lang_name": "English",
		"on": "ON",
		"off": "OFF",
		"reset": "Erase progress",
		"reset_confirm": "Are you sure? Tap again",
		"select_level": "Choose a level",
		"level": "LEVEL",
		"locked": "LOCKED",
		"soon": "COMING SOON",
		"soon_toast": "This level arrives in a future Sprint!",
		"armor_title": "The Armor of God",
		"armor_locked": "Beat level %d",
		"armor_future": "Coming soon",
		"faq_title": "Questions & Answers",
	},
}


static func get_text(lang: String, key: String) -> String:
	if DATA.has(lang) and DATA[lang].has(key):
		return str(DATA[lang][key])
	return str(DATA["pt"].get(key, key))
