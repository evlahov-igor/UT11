﻿#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ОтгружатьЕслиДоступно") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Результат = ОбеспечениеВДокументахВызовСервера.ОбработкаПолученияДанныхВыбораВариантаОбеспечения(Параметры);
		
		Упаковка = Параметры.Упаковка;
		Если Не ЗначениеЗаполнено(Упаковка) Тогда
			Если ЗначениеЗаполнено(Результат.ЕдиницаИзмерения) Тогда
				Упаковка = Результат.ЕдиницаИзмерения;
			КонецЕсли;
		КонецЕсли;
		
		ТребуетсяУказаниеСерийВСтроке = Результат.ТребуетсяУказаниеСерийВСтроке;
		ТребуетсяВыборСклада = Параметры.Свойство("НесколькоСкладов")
			И Параметры.НесколькоСкладов
			И (Параметры.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар")
				Или Параметры.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.МногооборотнаяТара"));
		
		ДанныеВыбора = Новый СписокЗначений();
		
		Значение = Новый Структура();
		Значение.Вставить("ВариантОбеспечения");
		Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Ложь);
		Значение.Вставить("РазбитьСтроку", Ложь);
		
		Значение.ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.НеТребуется");
		ДанныеВыбора.Добавить(Значение, НСтр("ru = 'Не обеспечивать'"));
		
		Значение = Новый Структура();
		Значение.Вставить("ВариантОбеспечения");
		Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Ложь);
		Значение.Вставить("РазбитьСтроку", Ложь);
		Значение.ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.КОбеспечению");
		ДанныеВыбора.Добавить(Значение, НСтр("ru = 'К обеспечению'"));
		
		Значение = Новый Структура();
		Значение.Вставить("ВариантОбеспечения");
		Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Ложь);
		Значение.Вставить("РазбитьСтроку", Ложь);
		Значение.ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.РезервироватьПоМереПоступления");
		ДанныеВыбора.Добавить(Значение, НСтр("ru = 'Резервировать по мере поступления'"));
		
		Если Параметры.КоличествоУпаковок > 0 Тогда
			
			Если (Параметры.ВариантОбеспечения <> ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.РезервироватьПоМереПоступления")
					И Параметры.ВариантОбеспечения <> ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.НеТребуется")
					И Параметры.ВариантОбеспечения <> ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.КОбеспечению"))
					Или Не Параметры.ОтгружатьЕслиДоступно
					Или Параметры.КоличествоУпаковок <= Параметры.Доступно
					Или Результат.ДопустимоеОтклонение > 0
						И Параметры.Количество * Результат.КоэффициентУпаковки <= Параметры.Доступно Тогда
				
				Значение = Новый Структура();
				Значение.Вставить("ВариантОбеспечения");
				Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Ложь);
				Значение.Вставить("РазбитьСтроку", Ложь);
				Значение.ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.СоСклада");
				ДанныеВыбора.Добавить(Значение, НСтр("ru = 'Резервировать на складе (все)'"));
				
				Значение = Новый Структура();
				Значение.Вставить("ВариантОбеспечения");
				Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Ложь);
				Значение.Вставить("РазбитьСтроку", Ложь);
				Значение.ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Отгрузить");
				ДанныеВыбора.Добавить(Значение, НСтр("ru = 'Отгрузить (все)'"));
				
				Если ТребуетсяУказаниеСерийВСтроке Или ТребуетсяВыборСклада Тогда
					
					Значение = Новый Структура();
					Значение.Вставить("ВариантОбеспечения");
					Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Ложь);
					Значение.Вставить("РазбитьСтроку", Ложь);
					Значение.ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.СоСклада");
					Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Истина);
					ДанныеВыбора.Добавить(Значение, НСтр("ru = 'Резервировать на складе ...'"));
					
					Значение = Новый Структура();
					Значение.Вставить("ВариантОбеспечения");
					Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Ложь);
					Значение.Вставить("РазбитьСтроку", Ложь);
					Значение.ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Отгрузить");
					Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Истина);
					ДанныеВыбора.Добавить(Значение, НСтр("ru = 'Отгрузить ...'"));
					
				КонецЕсли;
				
			Иначе
				
				Если (Не Параметры.Свойство("ИспользоватьЧастичнуюОтгрузку") Или Параметры.ИспользоватьЧастичнуюОтгрузку)
						И Параметры.Доступно > 0 Тогда
					
					Текст = НСтр("ru = 'Резервировать на складе: %1 %2'");
					Текст = СтрШаблон(Текст, Формат(Параметры.Доступно, "ЧДЦ=3"), Упаковка);
					
					Значение = Новый Структура();
					Значение.Вставить("ВариантОбеспечения");
					Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Ложь);
					Значение.Вставить("РазбитьСтроку", Ложь);
					Значение.ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.СоСклада");
					Значение.Вставить("РазбитьСтроку", Истина);
					ДанныеВыбора.Добавить(Значение, Текст);
					
					Текст = НСтр("ru = 'Отгрузить: %1 %2'");
					Текст = СтрШаблон(Текст, Формат(Параметры.Доступно, "ЧДЦ=3"), Упаковка);
					
					Значение = Новый Структура();
					Значение.Вставить("ВариантОбеспечения");
					Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Ложь);
					Значение.Вставить("РазбитьСтроку", Ложь);
					Значение.ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Отгрузить");
					Значение.Вставить("РазбитьСтроку", Истина);
					ДанныеВыбора.Добавить(Значение, Текст);
					
				КонецЕсли;
				
				Если ТребуетсяВыборСклада Тогда
					
						Значение = Новый Структура();
						Значение.Вставить("ВариантОбеспечения");
						Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Ложь);
						Значение.Вставить("РазбитьСтроку", Ложь);
						Значение.ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.СоСклада");
						Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Истина);
						ДанныеВыбора.Добавить(Значение, НСтр("ru = 'Резервировать на складе ...'"));
						
						Значение = Новый Структура();
						Значение.Вставить("ВариантОбеспечения");
						Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Ложь);
						Значение.Вставить("РазбитьСтроку", Ложь);
						Значение.ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Отгрузить");
						Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Истина);
						ДанныеВыбора.Добавить(Значение, НСтр("ru = 'Отгрузить ...'"));
						
				ИначеЕсли (Не Параметры.Свойство("ИспользоватьЧастичнуюОтгрузку") Или Параметры.ИспользоватьЧастичнуюОтгрузку)
								И ТребуетсяУказаниеСерийВСтроке И Параметры.Доступно > 0 Тогда
							
						Значение = Новый Структура();
						Значение.Вставить("ВариантОбеспечения");
						Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Ложь);
						Значение.Вставить("РазбитьСтроку", Ложь);
						Значение.ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.СоСклада");
						Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Истина);
						ДанныеВыбора.Добавить(Значение, НСтр("ru = 'Резервировать на складе ...'"));
						
						Значение = Новый Структура();
						Значение.Вставить("ВариантОбеспечения");
						Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Ложь);
						Значение.Вставить("РазбитьСтроку", Ложь);
						Значение.ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Отгрузить");
						Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Истина);
						ДанныеВыбора.Добавить(Значение, НСтр("ru = 'Отгрузить ...'"));
						
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
			
		Значение = Новый Структура();
		Значение.Вставить("ВариантОбеспечения");
		Значение.Вставить("ОткрытьФормуВыбораСкладаИСерий", Ложь);
		Значение.Вставить("РазбитьСтроку", Ложь);
		Значение.ВариантОбеспечения = ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.ПереданРанее");
		ДанныеВыбора.Добавить(Значение, НСтр("ru = 'Передан ранее'"));
		
		ДопустимыеДействия = Новый Массив();
		
		Если Параметры.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Товар")
				Или Параметры.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.МногооборотнаяТара") Тогда
				
				ДопустимыеДействия.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.НеТребуется"));
				ДопустимыеДействия.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.КОбеспечению"));
				ДопустимыеДействия.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.РезервироватьПоМереПоступления"));
				ДопустимыеДействия.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.СоСклада"));
				ДопустимыеДействия.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Отгрузить"));
				ДопустимыеДействия.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.ПереданРанее"));
				
		ИначеЕсли Параметры.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Услуга")
					Или Параметры.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа")
						И Не Параметры.Обособленно Тогда
				
				ДопустимыеДействия.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.НеТребуется"));
				ДопустимыеДействия.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Отгрузить"));
				
		ИначеЕсли Параметры.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Работа") Тогда
				
				ДопустимыеДействия.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.КОбеспечению"));
				ДопустимыеДействия.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыОбеспечения.Отгрузить"));
				
		КонецЕсли;
		
		Если Параметры.Свойство("ДопустимыеДействия") Тогда
			ДопустимыеДействияВДокументе = Параметры.ДопустимыеДействия;
		Иначе
			ДопустимыеДействияВДокументе = ОбеспечениеВДокументахКлиентСервер.ДоступныеДействияДляВыбораОбеспеченияВСтрокеПоУмолчанию();
		КонецЕсли;
		
		КоличествоЭлементов = ДанныеВыбора.Количество();
		Для Счетчик = 1 По КоличествоЭлементов Цикл
			
			ТекущееДействие = ДанныеВыбора[КоличествоЭлементов - Счетчик].Значение.ВариантОбеспечения;
			Если ДопустимыеДействия.Найти(ТекущееДействие) = Неопределено
					Или ДопустимыеДействияВДокументе.Найти(ТекущееДействие) = Неопределено Тогда
				
				ДанныеВыбора.Удалить(ДанныеВыбора[КоличествоЭлементов - Счетчик]);
				
			КонецЕсли;
			
		КонецЦикла;
	
	Иначе
		
		СтандартнаяОбработка = Ложь;
		ДанныеВыбора = Новый СписокЗначений();
		ДанныеВыбора.Добавить(Перечисления.ВариантыОбеспечения.Отгрузить);
		ДанныеВыбора.Добавить(Перечисления.ВариантыОбеспечения.СоСклада);
		ДанныеВыбора.Добавить(Перечисления.ВариантыОбеспечения.РезервироватьПоМереПоступления);
		ДанныеВыбора.Добавить(Перечисления.ВариантыОбеспечения.КОбеспечению);
		ДанныеВыбора.Добавить(Перечисления.ВариантыОбеспечения.НеТребуется);
		ДанныеВыбора.Добавить(Перечисления.ВариантыОбеспечения.ПереданРанее);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти