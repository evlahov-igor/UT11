﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыОтбора = Новый Структура("Номенклатура", ПараметрКоманды);
	ПараметрыФормы = Новый Структура("Отбор, СформироватьПриОткрытии, ВидимостьКомандВариантовОтчетов", 
		ПараметрыОтбора, 
		Истина,
		Ложь);
		
	ОткрытьФорму(
		"Отчет.СостояниеАссортимента.Форма",
		ПараметрыФормы,
		,
		"Номенклатура = " + ПараметрКоманды,
		ПараметрыВыполненияКоманды.Окно);
КонецПроцедуры

#КонецОбласти
