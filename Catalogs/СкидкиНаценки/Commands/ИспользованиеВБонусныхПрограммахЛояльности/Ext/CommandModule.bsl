﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура("СкидкаНаценка", ПараметрКоманды);
	ОткрытьФорму("Справочник.СкидкиНаценки.Форма.ИспользованиеВБонусныхПрограммахЛояльности", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры
