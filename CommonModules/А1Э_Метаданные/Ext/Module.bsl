﻿#Если НЕ Клиент Тогда
	Функция ОбъектСуществует(ТипОбъекта, ИмяОбъекта) Экспорт
		Возврат Метаданные[ТипОбъекта].Найти(ИмяОбъекта) <> Неопределено;		
	КонецФункции
	
	Функция МенеджерТипаОбъектов(Знач ТипОбъекта) Экспорт
		ТипОбъекта = ВРЕГ(ТипОбъекта);
		Идентификатор = Лев(ТипОбъекта, 3);
		Если Идентификатор = "СПР" Тогда
			Возврат Справочники;
		ИначеЕсли Идентификатор = "ДОК" Тогда
			Возврат Документы;
		ИначеЕсли Идентификатор = "КОН" Тогда
			Возврат Константы;
		ИначеЕсли Идентификатор = "ЖУР" Тогда
			Возврат ЖурналыДокументов;
		ИначеЕсли Идентификатор = "ОБР" Тогда
			Возврат Обработки;
		ИначеЕсли Идентификатор = "ОТЧ" Тогда
			Возврат Отчеты;
		ИначеЕсли Идентификатор = "РЕГ" Тогда
			ДопИдентификатор = ?(Сред(ТипОбъекта, 8, 1) = "Ы", Сред(ТипОбъекта, 9, 3), Сред(ТипОбъекта, 8, 3));
			Если ДопИдентификатор = "СВЕ" Тогда Возврат РегистрыСведений
			ИначеЕсли ДопИдентификатор = "НАК" Тогда Возврат РегистрыНакопления
			ИначеЕсли ДопИдентификатор = "БУХ" Тогда Возврат РегистрыБухгалтерии
			ИначеЕсли ДопИдентификатор = "РАС" Тогда Возврат РегистрыРасчета
			КонецЕсли;
		ИначеЕсли Идентификатор = "ПЕР" Тогда
			Возврат Перечисления;
		ИначеЕсли Идентификатор = "ЗАД" Тогда
			Возврат Задачи;
		ИначеЕсли Идентификатор = "БИЗ" Тогда
			Возврат БизнесПроцессы;
		КонецЕсли;
		А1Э_Служебный.СлужебноеИсключение("Поддержка типа объектов " + ТипОбъекта + " не реализована!");
	КонецФункции
	
	// Возвращает менеджер объекта, вроде Справочники.Номенклатура или Документы.РеализацияТоваровИУслуг
	//
	// Параметры:
	//  Идентификатор	 - Строка, Ссылка, Тип, ОбъектМетаданных - если строка, то можно указывать полное имя (Справочник.Номенклатура) или сокращенное (Номенклатура).
	//  ТипОбъекта		 - Строка - можно указывать, если Идентификатор содержит сокращенное имя. Если не указывать, то будет глобальный поиск.  
	// 
	// Возвращаемое значение:
	//   - менеджер объекта
	//
	Функция МенеджерОбъекта(Идентификатор, Знач ТипОбъекта = Неопределено) Экспорт
		Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
			Если НЕ ЗначениеЗаполнено(ТипОбъекта) Тогда
				ЧастиИдентификатора = А1Э_Строки.ПередПосле(Идентификатор, ".");
				Если ЧастиИдентификатора.После = "" Тогда
					ТипОбъекта = ТипМетаданных(Идентификатор);
				Иначе
					Возврат МенеджерТипаОбъектов(ЧастиИдентификатора.Перед)[ЧастиИдентификатора.После]; 
				КонецЕсли;
			КонецЕсли;
			Возврат МенеджерТипаОбъектов(ТипОбъекта)[Идентификатор];
		ИначеЕсли ТипЗнч(Идентификатор) = Тип("Тип") Тогда 
			Возврат МенеджерПоСсылке(Новый(Идентификатор));
		ИначеЕсли ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
			ЧастиИмени = А1Э_Строки.ПередПосле(Идентификатор.ПолноеИмя(), "."); 
			Возврат МенеджерТипаОбъектов(ЧастиИмени.Перед)[ЧастиИмени.После] 
		ИначеЕсли А1Э_СтандартныеТипы.ЭтоСсылка(Идентификатор) Тогда
			Возврат МенеджерПоСсылке(Идентификатор);			
		Иначе
			А1Э_Служебный.ИсключениеНеверныйТип("Идентификатор", "А1Э_Метаданные.МенеджерОбъекта", Идентификатор, "Строка,Тип,Ссылка,ОбъектМетаданных");
		КонецЕсли;
	КонецФункции 
	
	Функция ТипМетаданных(Идентификатор) Экспорт
		Если ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
			Возврат А1Э_Строки.Перед(Идентификатор.ПолноеИмя(), ".");
		КонецЕсли;
		ОбъектМетаданных = Метаданные.Справочники.Найти(Идентификатор);
		Если ОбъектМетаданных <> Неопределено Тогда
			Возврат "СПРАВОЧНИКИ";
		КонецЕсли;
		ОбъектМетаданных = Метаданные.Документы.Найти(Идентификатор);
		Если ОбъектМетаданных <> Неопределено Тогда
			Возврат "ДОКУМЕНТЫ";
		КонецЕсли;
		ОбъектМетаданных = Метаданные.ЖурналыДокументов.Найти(Идентификатор);
		Если ОбъектМетаданных <> Неопределено Тогда
			Возврат "ЖУРНАЛЫДОКУМЕНТОВ";
		КонецЕсли;
		ОбъектМетаданных = Метаданные.Константы.Найти(Идентификатор);
		Если ОбъектМетаданных <> Неопределено Тогда
			Возврат "КОНСТАНТЫ";
		КонецЕсли;
		
		А1Э_Служебный.СлужебноеИсключение("Идентификатору " + Идентификатор + " не удалось сопоставить объект метаданных!");
	КонецФункции
	
	Функция МассивПолныхИмен(Знач Ссылки) Экспорт
		Ссылки = А1Э_Массивы.Массив(Ссылки);
		МассивТипов = А1Э_СтандартныеТипы.МассивТипов(Ссылки);
		Результат = Новый Массив;
		Для Каждого Тип Из МассивТипов Цикл
			ПустаяСсылка = Новый(Тип); 
			Результат.Добавить(ПустаяСсылка.Метаданные().ПолноеИмя());
		КонецЦикла;
		Возврат Результат;
	КонецФункции
	
	Функция ПолноеИмя(Ссылка) Экспорт
		Возврат Ссылка.Метаданные().ПолноеИмя();
	КонецФункции
	
	Функция МенеджерПоСсылке(Ссылка) Экспорт 
		Возврат МенеджерОбъекта(Ссылка.Метаданные().ПолноеИмя()); 
	КонецФункции
	
	// Возвращает объект метаданных, соответствующий идентификатору.
	//
	// Параметры:
	//  Идентификатор	 - Строка, ОбъектМетаданных,ЛюбаяСсылка,ЛюбойОбъект - 
	// 
	// Возвращаемое значение:
	//   - ОбъектМетаданных
	//
	Функция ОбъектМетаданных(Идентификатор) Экспорт
		Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
			Массив = А1Э_Строки.Разделить(Идентификатор, ".");
			Если Массив.Количество() = 1 Тогда
				Возврат ТипМетаданных(Массив[0]).Массив[0];
			ИначеЕсли Массив.Количество() = 2 Тогда
				Возврат ТипМетаданныхПоИмени(Массив[0])[Массив[1]]; 
			Иначе
				ВызватьИсключение "Идентификатор метаданных из более чем 2 частей не поддерживается!";
			КонецЕсли;
		ИначеЕсли ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
			Возврат Идентификатор;
		ИначеЕсли ТипЗнч(Идентификатор) = Тип("Тип") Тогда
			ПустаяСсылка = Новый(Идентификатор); 
			Возврат ПустаяСсылка.Метаданные();
		ИначеЕсли А1Э_Общее.Свойство(Идентификатор, "Ссылка") Тогда //Наивная проверка на ЛюбаяСсылка/ЛюбойОбъект. 
			Возврат Идентификатор.Метаданные();
		КонецЕсли;
		
		ВызватьИсключение "Идентификатору " + Идентификатор + " не удалось сопоставить объект метаданных!"
	КонецФункции
	
	// Получает объект метаданных по полному имени. Если объект не найден, возвращает Неопределено.
	//
	// Параметры:
	//  ПолноеИмяОбъектаМетаданных	 - Строка - <ТипМетаданных>.<ИмяМетаданных>
	// 
	// Возвращаемое значение:
	//   - ОбъектМетаданных, Неопределено
	//
	Функция ОбъектМетаданныхБезопасно(ПолноеИмяОбъектаМетаданных) Экспорт
		ЧастиИмени = А1Э_Строки.Разделить(ПолноеИмяОбъектаМетаданных, ".");
		Возврат ТипМетаданныхПоИмени(ЧастиИмени[0]).Найти(ЧастиИмени[1]); 
	КонецФункции
	
	Функция ТипМетаданныхПоИмени(Знач Имя) Экспорт 
		Имя = ВРЕГ(Имя);
		Идентификатор = Лев(Имя, 3);
		Если Идентификатор = "СПР" Тогда
			Возврат Метаданные.Справочники;
		ИначеЕсли Идентификатор = "ДОК" Тогда
			Возврат Метаданные.Документы;
		ИначеЕсли Идентификатор = "РЕГ" Тогда
			ДопИдентификатор = ?(Сред(Имя, 8, 1) = "Ы", Сред(Имя, 9, 3), Сред(Имя, 8, 3));
			Если ДопИдентификатор = "СВЕ" Тогда Возврат Метаданные.РегистрыСведений
			ИначеЕсли ДопИдентификатор = "НАК" Тогда Возврат Метаданные.РегистрыНакопления
			ИначеЕсли ДопИдентификатор = "БУХ" Тогда Возврат Метаданные.РегистрыБухгалтерии
			ИначеЕсли ДопИдентификатор = "РАС" Тогда Возврат Метаданные.РегистрыРасчета
			КонецЕсли;
		ИначеЕсли Идентификатор = "ОТЧ" Тогда
			Возврат Метаданные.Отчеты;
		ИначеЕсли Идентификатор = "ОБР" Тогда
			Возврат Метаданные.Обработки;
		ИначеЕсли Идентификатор = "ОБЩ" Тогда
			ДопИдентификатор = Сред(Имя, 6, 3);
			Если ДопИдентификатор = "КАР" Тогда Возврат Метаданные.ОбщиеКартинки
			ИначеЕсли ДопИдентификатор = "КОМ" Тогда Возврат Метаданные.ОбщиеКоманды
			ИначеЕсли ДопИдентификатор = "МАК" Тогда Возврат Метаданные.ОбщиеМакеты
			ИначеЕсли ДопИдентификатор = "МОД" Тогда Возврат Метаданные.ОбщиеМодули
			ИначеЕсли ДопИдентификатор = "РЕК" Тогда Возврат Метаданные.ОбщиеРеквизиты
			ИначеЕсли ДопИдентификатор = "ФОР" Тогда Возврат Метаданные.ОбщиеФормы
			КонецЕсли;
		ИначеЕсли Идентификатор = "ПЛА" Тогда
			ДопИдентификатор = ?(Сред(Имя, 5, 1) = "Ы", Сред(Имя, 6, 6), Сред(Имя, 5, 6));
			Если ДопИдентификатор = "ОБМЕНА" Тогда Возврат Метаданные.ПланыОбмена;
			ИначеЕсли ДопИдентификатор = "СЧЕТОВ" Тогда Возврат Метаданные.ПланыСчетов;
			ИначеЕсли ДопИдентификатор = "ВИДОВР" Тогда Возврат Метаданные.ПланыВидовРасчета;
			ИначеЕсли ДопИдентификатор = "ВИДОВХ" Тогда Возврат Метаданные.ПланыВидовХарактеристик;
			КонецЕсли;
		ИначеЕсли Идентификатор = "КОН" Тогда
			Возврат Метаданные.Константы;
		ИначеЕсли Идентификатор = "ПОС" Тогда
			Возврат Метаданные.Последовательности;
		ИначеЕсли Идентификатор = "БИЗ" Тогда
			Возврат Метаданные.БизнесПроцессы;
		ИначеЕсли Идентификатор = "ЗАД" Тогда
			Возврат Метаданные.Задачи;
		КонецЕсли;
		
		ВызватьИсключение "Имя типа метаданных " + Имя + " не существует или не поддерживается!";
		
	КонецФункции 
	
	Функция КолонкиРегистра(Идентификатор) Экспорт
		МетаданныеРегистра = ОбъектМетаданных(Идентификатор);
		Результат = Новый Массив;
		Для Каждого Измерение Из МетаданныеРегистра.Измерения Цикл
			Результат.Добавить(Измерение);
		КонецЦикла;
		Для Каждого Ресурс Из МетаданныеРегистра.Ресурсы Цикл
			Результат.Добавить(Ресурс);
		КонецЦикла;
		Для Каждого Реквизит Из МетаданныеРегистра.Реквизиты Цикл
			Результат.Добавить(Реквизит);
		КонецЦикла;
		Возврат Результат;
	КонецФункции 
	
	Функция ПредставлениеОдного(Идентификатор) Экспорт
		ОбъектМетаданных = ОбъектМетаданных(Идентификатор);
		Представление = ОбъектМетаданных.ПредставлениеОбъекта;
		Если Представление = "" Тогда
			Представление = ОбъектМетаданных.Синоним;
		КонецЕсли;
		Возврат Представление;
	КонецФункции
	
	Функция ПредставлениеНескольких(Идентификатор) Экспорт
		ОбъектМетаданных = ОбъектМетаданных(Идентификатор);
		Представление = ОбъектМетаданных.ПредставлениеСписка;
		Если Представление = "" Тогда
			Представление = ОбъектМетаданных.Синоним;
		КонецЕсли;
		Возврат Представление;
	КонецФункции 	
	
	// Получает макет по полному имени.
	//
	// Параметры:
	//  ПолноеИмяМакета	 - Строка -  
	// 
	// Возвращаемое значение:
	//   - 
	//
	Функция Макет(ПолноеИмяМакета) Экспорт
		ЧастиИмени = А1Э_Строки.Разделить(ПолноеИмяМакета, ".");
		Если ЧастиИмени.Количество() = 2 Тогда //Это общий макет.
			Возврат ПолучитьОбщийМакет(ЧастиИмени[1]);
		ИначеЕсли ЧастиИмени.Количество() = 3 Тогда
			МенеджерОбъекта = МенеджерОбъекта(ЧастиИмени[1], ЧастиИмени[0]);
			Возврат МенеджерОбъекта.ПолучитьМакет(ЧастиИмени[2]);
		Иначе
			А1Э_Служебный.СлужебноеИсключение("Неверное имя макета. Ожидается ""ОбщийМакет.<ИмяМакета>"" или ""<ТипОбъектаМетаданных>.<ИмяОбъектаМетаданных>.<ИмяМакета>""!");
		КонецЕсли;
	КонецФункции 
	
	// Возвращает ОписаниеТипов указанного поля (реквизита или стандартного реквизита) соответствующего объекта метаданных.
	//
	// Параметры:
	//  ИдентификаторМетаданных	 - Строка, ОбъектМетаданных,ЛюбаяСсылка,ЛюбойОбъект - 
	//  ИмяПоля			         - Строка - 
	// 
	// Возвращаемое значение:
	//   - 
	//
	Функция ОписаниеТипаПоля(ИдентификаторМетаданных, ИмяПоля) Экспорт
		ОбъектМетаданных = ОбъектМетаданных(ИдентификаторМетаданных);
		Если ОбъектМетаданных.Реквизиты.Найти(ИмяПоля) <> Неопределено Тогда
			Возврат ОбъектМетаданных.Реквизиты[ИмяПоля].Тип;
		КонецЕсли;
		ТипМетаданных = ТипМетаданных(ОбъектМетаданных);
		Если ТипМетаданных = "Справочник" Тогда
			Если ИмяПоля = "Наименование" Тогда
				Возврат А1Э_Строки.ОписаниеТипа(ОбъектМетаданных.ДлинаНаименования);
			ИначеЕсли ИмяПоля = "Код" Тогда
				Если ОбъектМетаданных.ТипКода = Метаданные.СвойстваОбъектов.ТипКодаСправочника.Строка Тогда
					Возврат А1Э_Строки.ОписаниеТипа(ОбъектМетаданных.ДлинаКода);
				Иначе
					Возврат А1Э_Числа.ОписаниеТипа(ОбъектМетаданных.ДлинаКода);
				КонецЕсли;
			ИначеЕсли ИмяПоля = "Владелец" Тогда
				Если ОбъектМетаданных.Владельцы.Количество() = 0 Тогда
					Возврат Null;
				Иначе
					МассивТипов = Новый Массив;
					Для Каждого Владелец Из ОбъектМетаданных.Владельцы Цикл
						МассивТипов.Добавить(А1Э_СтандартныеТипы.ТипПолучить(Владелец.ПолноеИмя()));
					КонецЦикла;
					Возврат Новый ОписаниеТипов(МассивТипов);
				КонецЕсли;
			ИначеЕсли ИмяПоля = "ЭтоГруппа" Тогда
				Возврат Новый ОписаниеТипов("Булево");
			КонецЕсли;
		ИначеЕсли ТипМетаданных = "Документ" Тогда
			Если ИмяПоля = "Номер" Тогда
				Возврат А1Э_Строки.ОписаниеТипа(ОбъектМетаданных.ДлинаНомера);
			ИначеЕсли ИмяПоля = "Дата" Тогда
				Возврат А1Э_Даты.ОписаниеТипа();
			КонецЕсли;
		КонецЕсли;
		
		А1Э_Служебный.СлужебноеИсключение("Определение типа поля " + ИмяПоля + " не поддерживается у метаданных " + ОбъектМетаданных.ПолноеИмя());
		
	КонецФункции
	
	// Возвращает описание типа колонки (реквизита) табличной части соответствующего объекта метаданных.
	//
	// Параметры:
	//  ИдентификаторМетаданных	 - Строка, ОбъектМетаданных,ЛюбаяСсылка,ЛюбойОбъект -
	//  ИмяТабличнойЧасти		 - Строка - 
	//  ИмяКолонки				 - Строка - 
	// 
	// Возвращаемое значение:
	//   - 
	//
	Функция ОписаниеТипаКолонки(ИдентификаторМетаданных, ИмяТабличнойЧасти, ИмяКолонки) Экспорт
		ОбъектМетаданных = ОбъектМетаданных(ИдентификаторМетаданных);
		Если ОбъектМетаданных.ТабличныеЧасти.Найти(ИмяТабличнойЧасти) = Неопределено Тогда
			А1Э_Служебный.СлужебноеИсключение("При попытке определения типа колонки в метаданных " + ОбъектМетаданных.ПолноеИмя() + " не найдена табличная часть " + ИмяТабличнойЧасти);
		КонецЕсли;
		ТабличнаяЧасть = ОбъектМетаданных.ТабличныеЧасти[ИмяТабличнойЧасти];
		Если ТабличнаяЧасть.Реквизиты.Найти(ИмяКолонки) = Неопределено Тогда
			А1Э_Служебный.СлужебноеИсключение("При попытке определения типа колонки в метаданных " + ОбъектМетаданных.ПолноеИмя() + " у табличной части " + ИмяТабличнойЧасти + " не найдена колонка " + ИмяКолонки);
		КонецЕсли;
		Возврат ТабличнаяЧасть.Реквизиты[ИмяКолонки].Тип;
	КонецФункции
	
	Функция Роль(Идентификатор) Экспорт
		Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
			Возврат Метаданные.Роли[Идентификатор];
		ИначеЕсли ТипЗнч(Идентификатор) = Тип("ОбъектМетаданных") Тогда
			Возврат Идентификатор;
		Иначе
			А1Э_Служебный.ИсключениеНеверныйТип("Идентификатор", ИмяМодуля() + "Роль", Идентификатор, "Строка,ОбъектМетаданных");
		КонецЕсли;
	КонецФункции 
	
#КонецЕсли

Функция ОбщийМодуль(Имя, ВызыватьИсключение = Ложь) Экспорт
	Если НЕ А1Э_Строки.ЭтоИдентификатор(Имя) Тогда
		А1Э_Служебный.СлужебноеИсключение("Имя, переданное в функцию " + ИмяМодуля() + ".ОбщийМодуль(), не может быть именем общего модуля!");
	КонецЕсли;
	
	#Если НЕ Клиент Тогда
		Если Метаданные.ОбщиеМодули.Найти(Имя) = Неопределено Тогда 
			Если НЕ ВызыватьИсключение Тогда Возврат Неопределено; КонецЕсли;
			А1Э_Служебный.СлужебноеИсключение("Общий модуль <" + Имя + "> не обнаружен в текущем контексте!");
		КонецЕсли;
	#КонецЕсли
	
	Попытка
		Возврат Вычислить(Имя);
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		Если ВызыватьИсключение Тогда
			ВызватьИсключение ОписаниеОшибки;
		КонецЕсли;
		Возврат Неопределено;
	КонецПопытки;			
КонецФункции
	
#Область ИдентификаторыСсылок

Функция ИдентификаторПоСсылке(Ссылка) Экспорт 
	//Не работает для перечислений. Кроме того, новый вариант скорее всего быстрее.
	//Возврат СвязиСсылокИСистемныхКодов().ПоСсылке[А1Э_СтандартныеТипы.ПустаяСсылка(Ссылка)] + ":" + УИДСистемнаяСтрока(Ссылка.УникальныйИдентификатор());
	#Если Клиент Тогда
		Возврат А1Э_ОбщееСервер.РезультатФункции(ИмяМодуля() + ".ИдентификаторПоСсылке", Ссылка);
	#Иначе
		Если Ссылка = Неопределено Тогда Возврат "" КонецЕсли;
		Если ТипЗнч(Ссылка) = Тип("Строка") Тогда Возврат Ссылка КонецЕсли;
		Возврат А1Э_Строки.Перед(СтрРазделить(ЗначениеВСтрокуВнутр(Ссылка), ",")[2], "}");
	#КонецЕсли 
КонецФункции

Функция СсылкаПоИдентификатору(Идентификатор) Экспорт
	#Если Клиент Тогда
		Возврат А1Э_ОбщееСервер.РезультатФункции(ИмяМодуля() + ".СсылкаПоИдентификатору", Идентификатор);
	#Иначе
		Если ТипЗнч(Идентификатор) <> Тип("Строка") Тогда Возврат Идентификатор КонецЕсли;
		Если Идентификатор = "" Тогда Возврат Неопределено; КонецЕсли;
		
		ОписаниеИдентификатора = ОписаниеИдентификатора(Идентификатор);
		ОписаниеМетаданных = ОписаниеМетаданныхПоКоду(ОписаниеИдентификатора.Код);
				
		//Не работает для перечислений.
		//Возврат МенеджерОбъекта(ОписаниеМетаданных.Имя, ОписаниеМетаданных.Коллекция).ПолучитьСсылку(ОписаниеИдентификатора.УИД);
		ПустаяСсылка = МенеджерОбъекта(ОписаниеМетаданных.Имя, ОписаниеМетаданных.Коллекция).ПустаяСсылка();
		//В внутреннем значении пустой ссылки заменяем 32 нуля (признак пустой ссылки) на УИД.
		Возврат ЗначениеИзСтрокиВнутр(СтрЗаменить(ЗначениеВСтрокуВнутр(ПустаяСсылка), "00000000000000000000000000000000", ОписаниеИдентификатора.УИД));
		
	#КонецЕсли	
КонецФункции 	

Функция ПолноеИмяМетаданныхПоКоду(Код) Экспорт 
	СтруктураИмен = А1Э_Структуры.Создать(
	"Справочники", "Справочник",
	"Документы", "Документ",
	);
	ОписаниеМетаданных = ОписаниеМетаданныхПоКоду(Код);
	Возврат СтруктураИмен[ОписаниеМетаданных.Коллекция] + "." + ОписаниеМетаданных.Имя;
КонецФункции

Функция КодПоПолномуИмени(Имя) Экспорт
	Возврат СвязиСсылокИСистемныхКодов().ПоИмени[Имя];	
КонецФункции

Функция ОписаниеМетаданныхПоКоду(Код) Экспорт 
	Возврат СвязиСсылокИСистемныхКодов().ПоКоду[Код]; 	
КонецФункции

Функция СвязиСсылокИСистемныхКодов() Экспорт
	#Если НЕ Клиент Тогда
		УстановитьПривилегированныйРежим(Истина);
		ИмяПараметра = "А1Э_СвязиСсылокИСистемныхКодов";
		Возврат ПараметрыСеанса[ИмяПараметра];
	#Иначе
		Если А1Э_СвязиСсылокИСистемныхКодов = Неопределено Тогда
			А1Э_СвязиСсылокИСистемныхКодов = А1Э_ОбщееСервер.РезультатФункции("А1Э_Метаданные.СвязиСсылокИСистемныхКодов");
		КонецЕсли;
		Возврат А1Э_СвязиСсылокИСистемныхКодов;
	#КонецЕсли
КонецФункции

Функция ПравильныйУИД(УИДСистемнаяСтрока)
	Возврат Новый УникальныйИдентификатор(
	Сред(УИДСистемнаяСтрока, 25, 8) + "-" + Сред(УИДСистемнаяСтрока, 21, 4) + "-" + Сред(УИДСистемнаяСтрока, 17, 4) + "-" + Сред(УИДСистемнаяСтрока, 1, 4) + "-" + Сред(УИДСистемнаяСтрока, 5, 12));  
КонецФункции

Функция УИДСистемнаяСтрока(ПравильныйУИД)
	СтрокаУИД = Строка(ПравильныйУИД);
	Возврат Сред(СтрокаУИД, 20, 4) + Сред(СтрокаУИД, 25, 12) + Сред(СтрокаУИД, 15, 4) + Сред(СтрокаУИД, 10, 4) + Сред(СтрокаУИД, 1, 8); 
КонецФункции

#Если НЕ Клиент Тогда
	
	Функция УстановитьСвязьСсылокИСистемныхКодов() Экспорт
		ИмяПараметра = "А1Э_СвязиСсылокИСистемныхКодов";
		ПараметрыСеанса[ИмяПараметра] = РассчитатьСвязиСсылокИСистемныхКодов();
	КонецФункции
	
	Функция РассчитатьСвязиСсылокИСистемныхКодов() Экспорт
		ПоКоду = Новый Соответствие;
		ПоСсылке = Новый Соответствие;
		ПоИмени = Новый Соответствие;
		НеиспользуемыйУИД = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000001");
		Коллекции = А1Э_Массивы.Массив("Справочники,Документы,Перечисления,ПланыВидовХарактеристик,ПланыСчетов,ПланыВидовРасчета,БизнесПроцессы,Задачи");
		Для Каждого Коллекция Из Коллекции Цикл
			МенеджерКоллекции = Вычислить(Коллекция);
			МетаданныеКоллекции = Метаданные[Коллекция];
			Для Каждого ОбъектМетаданных Из МетаданныеКоллекции Цикл
				ОписаниеОбъектаМетаданных = Новый ФиксированнаяСтруктура(А1Э_Структуры.Создать(
				"Коллекция", Коллекция,
				"Имя", ОбъектМетаданных.Имя));
				МенеджерОбъектаМетаданных = МенеджерКоллекции[ОбъектМетаданных.Имя];
				//БитаяСсылка = МенеджерОбъектаМетаданных.ПолучитьСсылку(НеиспользуемыйУИД);
				ПустаяСсылка = МенеджерОбъектаМетаданных.ПустаяСсылка(); 
				КодОбъекта = А1Э_Строки.Перед(СтрРазделить(ЗначениеВСтрокуВнутр(ПустаяСсылка), ",")[2], ":");
				//СтрокаБитойСсылки = "" + БитаяСсылка;
				//ПоложениеСкобки = СтрНайти(СтрокаБитойСсылки, "(");
				//ПоложениеДвоеточия = СтрНайти(СтрокаБитойСсылки, ":");
				//КодОбъекта = Сред(СтрокаБитойСсылки, ПоложениеСкобки + 1, ПоложениеДвоеточия - ПоложениеСкобки - 1);
				ПоКоду.Вставить(КодОбъекта, ОписаниеОбъектаМетаданных);
				ПоСсылке.Вставить(ПустаяСсылка, КодОбъекта);
				ПоИмени.Вставить(ОбъектМетаданных.ПолноеИмя(), КодОбъекта); 
			КонецЦикла;
		КонецЦикла;
		Результат = Новый ФиксированнаяСтруктура(А1Э_Структуры.Создать(
		"ПоКоду", Новый ФиксированноеСоответствие(ПоКоду),
		"ПоСсылке", Новый ФиксированноеСоответствие(ПоСсылке),
		"ПоИмени", Новый ФиксированноеСоответствие(ПоИмени), 
		));
		Возврат Результат;
	КонецФункции 
	
	Функция ОписаниеИдентификатора(Идентификатор) 
		Данные = А1Э_Строки.ПередПосле(Идентификатор, ":");
		Возврат Новый Структура("Код,УИД", Данные.Перед, Данные.После);
	КонецФункции
	
	Функция БитыйУИД()
		Возврат Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000001");
	КонецФункции
	
#КонецЕсли
#КонецОбласти 

Функция ОбщиеМодулиСВычислением(ПовторноеИспользование = Истина) Экспорт 
	Если ПовторноеИспользование = Истина Тогда
		Возврат А1Э_ПовторноеИспользование.РезультатФункции("А1Э_Метаданные.ОбщиеМодули", Ложь);
	КонецЕсли;
	
	ОбщиеМодулиПоМетаданным = А1Э_ОбщееСервер.РезультатФункции("А1Э_Метаданные.ОбщиеМодули");
	Результат = Новый Соответствие;
	Для Каждого Пара Из ОбщиеМодулиПоМетаданным Цикл
		#Если Клиент Тогда
			Если НЕ (Пара.Значение.Клиент Или Пара.Значение.ВызовСервере) Тогда
				Продолжить;
			КонецЕсли;
		#ИначеЕсли Сервер Тогда
			Если НЕ (Пара.Значение.Сервер) Тогда
				Продолжить;
			КонецЕсли;
		#ИначеЕсли ВнешнееСоединение Тогда
			Если НЕ (Пара.Значение.ВнешнееСоединение) Тогда
				Продолжить;
			КонецЕсли;
		#Иначе
			А1Э_Служебный.СлужебноеИсключение("Поддерживается выполнение на клиенте, сервере или внешнем соединении!");
		#КонецЕсли
		Результат.Вставить(Пара.Ключ, Вычислить(Пара.Ключ)); 
	КонецЦикла;
	Возврат Результат;
КонецФункции 

#Область ДанныеОбщихМодулей

Функция ДанныеОбщихМодулей(ПовторноеИспользование = Истина) Экспорт 
	Если ПовторноеИспользование = Истина Тогда
		Возврат А1Э_ПовторноеИспользование.РезультатФункции("А1Э_Метаданные.ДанныеОбщихМодулей", Ложь);
	КонецЕсли;
	#Если Клиент Тогда
		Возврат А1Э_ОбщееСервер.РезультатФункции("А1Э_Метаданные.ДанныеОбщихМодулей");
	#Иначе
		Соответствие = Новый Соответствие;
		Для Каждого ОбщийМодуль Из Метаданные.ОбщиеМодули Цикл
			Структура = Новый Структура("Имя,Клиент,Сервер,ВнешнееСоединение,ВызовСервера");
			ЗаполнитьЗначенияСвойств(Структура, ОбщийМодуль);
			Соответствие.Вставить(ОбщийМодуль.Имя, Структура);
		КонецЦикла;
		Возврат Соответствие;
	#КонецЕсли
КонецФункции

Функция ДанныеОбщегоМодуля(ПолноеИмя) Экспорт
	Возврат А1Э_ПовторноеИспользование.РезультатФункции("А1Э_Метаданные.ДанныеОбщихМодулей")[ПолноеИмя];
КонецФункции 

#КонецОбласти 

Функция ИмяМодуля() Экспорт
	Возврат "А1Э_Метаданные";
КонецФункции 