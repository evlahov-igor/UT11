﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
			
КонецПроцедуры

&НаСервере
Функция ДоступнаРольПолныеПрава()

	Возврат РольДоступна("ПолныеПрава");	
	
КонецФункции

&НаКлиенте
Процедура ОткрытьНастройкиПодключенияЯндексМаркет(Команда)
	
		ЕстьАктуальныеНастройки  = ЕстьАктуальныеНастройкиЯндексМаркетФулфилмент();
		
		Если ЕстьАктуальныеНастройки И ДоступнаРольПолныеПрава() Тогда
			
			ОткрытьФорму(
			"Обработка.ЯндексМаркетВитринаФулфилмент.Форма.ОчисткаНастроекПодключения",
			,,Истина);
			
		Иначе
			
			Если ДоступнаРольПолныеПрава() Тогда		
					
				ОткрытьФорму(
				"Обработка.ЯндексМаркетВитринаФулфилмент.Форма.ПодключениеКСервису",
				,,Истина); 
				
			Иначе
				ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru = 'Для изменения настроек подключения пользователю должны быть назначены административные права.'"));	
			КонецЕсли; 
				
		КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПубликациюТоваров(Команда)
	
		ЕстьАктуальныеНастройки  = ЕстьАктуальныеНастройкиЯндексМаркетФулфилмент();
		
		Если ЕстьАктуальныеНастройки Тогда
			
			ОткрытьФорму(
			"Обработка.ЯндексМаркетВитринаФулфилмент.Форма.ВыгрузкаТоварногоКаталога",
			,,Истина);
			
		Иначе
			
			ОткрытьФорму(
			"Обработка.ЯндексМаркетВитринаФулфилмент.Форма.ПодключениеКСервису",
			,,Истина);
				
		КонецЕсли;


КонецПроцедуры


#КонецОбласти

#Область Сервер

&НаСервере
Функция ЕстьАктуальныеНастройкиЯндексМаркетФулфилмент()
	ЕстьАктуальныеНастройки = Ложь;	
	
	УстановитьПривилегированныйРежим(Истина);
	Организация = ИнтеграцияСЯндексМаркетСервер.ТекущиеДанныеАвторизацииОрганизация();
	
	Если Организация <> Неопределено И ТипЗнч(Организация) = Тип("СправочникСсылка.Организации") Тогда  
		ДанныеАвторизации = ИнтеграцияСЯндексМаркетСервер.ТекущиеДанныеАвторизации(Организация);
		Если ДанныеАвторизации.Свойство("access_token") 
			И ДанныеАвторизации.Свойство("access_token_expires")
			И ДанныеАвторизации.Свойство("refresh_token") Тогда
			
			ЕстьАктуальныеНастройки = Истина;
			
		КонецЕсли;  	
	КонецЕсли;  
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат ЕстьАктуальныеНастройки;
	
КонецФункции

#КонецОбласти
