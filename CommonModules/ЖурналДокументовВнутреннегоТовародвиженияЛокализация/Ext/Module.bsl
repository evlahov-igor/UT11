﻿////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции, используемые в обработке ЖурналДокументовВнутреннегоТовародвижения.
// 
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

Процедура ОписаниеОперацийИТиповДокументов(ТЗХозОперацииИТипыДокументов) Экспорт

	//++ Локализация
	
	#Область ВнутреннееПотреблениеТоваров
	
	Строка = ТЗХозОперацииИТипыДокументов.Добавить();
	Строка.ХозяйственнаяОперация		= Перечисления.ХозяйственныеОперации.ПередачаВЭксплуатацию;
	Строка.КлючНазначенияИспользования	= "ВнутренниеПотребленияТоваров";
	Строка.ЗаголовокРабочегоМеста		= НСтр("ru = 'Внутренние документы (внутренние потребления товаров)'");
	Строка.ТипДокумента					= Тип("ДокументСсылка.ВнутреннееПотреблениеТоваров");
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.ВнутреннееПотреблениеТоваров.ПолноеИмя();
	Строка.ИспользуютсяСтатусы			= ПолучитьФункциональнуюОпцию("ИспользоватьСтатусыВнутреннихПотреблений");
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.МенеджерРасчетаГиперссылкиКОформлению = "Обработка.ЖурналДокументовВнутреннегоТовародвижения";
	Строка.КлючевыеПоляШапки			= Документы.ВнутреннееПотреблениеТоваров.КлючевыеПоляШапкиРаспоряжения();
	Строка.ЗаголовокФормыПереоформления	= НСтр("ru = 'Переоформление передачи в эксплуатацию по выбранным распоряжениям'");
	
	#КонецОбласти
	
	#Область ПрочееОприходованиеТоваров
	
	Строка = ТЗХозОперацииИТипыДокументов.Добавить();
	Строка.ХозяйственнаяОперация		= Перечисления.ХозяйственныеОперации.ВозвратИзЭксплуатации;
	Строка.КлючНазначенияИспользования	= "ПрочиеОприходованияТоваров";
	Строка.ЗаголовокРабочегоМеста		= НСтр("ru = 'Внутренние документы (прочие оприходования товаров)'");
	Строка.ТипДокумента					= Тип("ДокументСсылка.ПрочееОприходованиеТоваров");
	Строка.ПолноеИмяДокумента			= Метаданные.Документы.ПрочееОприходованиеТоваров.ПолноеИмя();
	Строка.ИспользуютсяСтатусы			= Ложь;
	Строка.ДобавитьКнопкуСоздать		= Истина;
	Строка.МенеджерРасчетаГиперссылкиКОформлению = "Обработка.ЖурналДокументовВнутреннегоТовародвижения";
	
	#КонецОбласти
	
	//-- Локализация
	
КонецПроцедуры

#КонецОбласти
