﻿////////////////////////////////////////////////////////////////////////////////
// Общий модуль ИнтеграцияКоммерческиеПредложения
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Функция НовыеПараметрыПоискаТорговыхПредложенийСОтборами(Организация = Неопределено) Экспорт
	
	ПараметрыПоиска = Новый Структура;
	Если ОбщегоНазначения.ПодсистемаСуществует("ЭлектронноеВзаимодействие.ТорговыеПредложения") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("ТорговыеПредложенияСлужебный");
		ПараметрыПоиска = МодульУправлениеДоступом.НовыеПараметрыПоискаТорговыхПредложенийСОтборами(Организация);
	КонецЕсли;
	
	Возврат ПараметрыПоиска;
	
КонецФункции

#КонецОбласти
