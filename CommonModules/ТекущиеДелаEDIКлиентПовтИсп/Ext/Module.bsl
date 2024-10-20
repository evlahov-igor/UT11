﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// В модуле реализованы клиент-серверные процедуры и функции, предназначенные для работы с текущими делами EDI
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Определяет имя формы прикладного объекта заказа поставщику
// 
// Возвращаемое значение:
// 	Строка - Полное имя формы прикладного заказа поставщику
Функция ИмяФормыЗаказПоставщику() Экспорт
	
	Возврат ТекущиеДелаEDIВызовСервера.ИмяФормыЗаказПоставщику();
	
КонецФункции

#КонецОбласти