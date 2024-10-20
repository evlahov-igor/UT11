﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	// &ЗамерПроизводительности
	// СтандартныеПодсистемы.ЗамерПроизводительности
	ОценкаПроизводительностиКлиент.ЗамерВремени("Обработка.ЖурналДокументовВводаНачальныхОстатков.Команда.ДокументыВводаНачальныхОстатков", Ложь, Истина);		
	// Конец СтандартныеПодсистемы.ЗамерПроизводительности
	
	ПараметрыФормы = Новый Структура("КлючНазначенияФормы", "ДокументыВводаНачальныхОстатков");
	
	ОткрытьФорму("Обработка.ЖурналДокументовВводаНачальныхОстатков.Форма.ФормаСписка",
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти 