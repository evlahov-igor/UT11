﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)

	ОценкаПроизводительностиКлиент.ЗамерВремени("Справочник.ВидыЦен.Форма.ФормаСписка.ПриОткрытии");
	
	ОткрытьФорму(
	"Справочник.ВидыЦен.Форма.ФормаСписка",
	,
	ПараметрыВыполненияКоманды.Источник,
	ПараметрыВыполненияКоманды.Уникальность,
	ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры