﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("БизнесПроцесс.СогласованиеЗакупки.ФормаОбъекта", Новый Структура("Основание",ПараметрКоманды));
	
КонецПроцедуры

#КонецОбласти
