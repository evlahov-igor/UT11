﻿

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("ТипОснованияАктаОРасхождении",
									ПредопределенноеЗначение("Перечисление.ТипыОснованияАктаОРасхождении.ВозвратТоваровОтХранителя"));
	
	ОткрытьФорму("Документ.АктОРасхожденияхПослеПриемки.ФормаСписка",
				ПараметрыФормы,
				ПараметрыВыполненияКоманды.Источник,
				"ПоступлениеТоваровОтХранителя",
				ПараметрыВыполненияКоманды.Окно,
				ПараметрыВыполненияКоманды.НавигационнаяСсылка);

КонецПроцедуры

#КонецОбласти

