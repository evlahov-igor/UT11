﻿

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("Обработка.ДоступныеАнкеты.Форма", 
	             ,
	             ПараметрыВыполненияКоманды.Источник,
	             ПараметрыВыполненияКоманды.Уникальность,
	             ПараметрыВыполненияКоманды.Окно,
	             ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

#КонецОбласти
