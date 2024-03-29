﻿#Если НЕ Клиент Тогда
	Функция Установить(Объект, Ключ, Значение) Экспорт 
		ОписаниеРеквизита = ОписаниеПоКлючу(Ключ);
		Если НЕ ПравоДоступа("Изменение", Объект.Ссылка.Метаданные()) Тогда
			ВызватьИсключение А1Э_Строки.ПоШаблону("Не удалось изменить реквизит [Заголовок] объекта [Объект] -  недостаточно прав доступа!",
			Новый Структура("Заголовок,Объект", ОписаниеРеквизита.Заголовок, Объект.Ссылка));
		КонецЕсли;
		МенеджерЗаписи = РегистрыСведений["А1_ПериодическиеРеквизиты"].СоздатьМенеджерЗаписи();
		МенеджерЗаписи.Период = ТекущаяДата();
		МенеджерЗаписи.Объект = Объект.Ссылка;
		МенеджерЗаписи.КлючРеквизита = Ключ;
		МенеджерЗаписи.Значение = Значение;
		МенеджерЗаписи.Пользователь = А1Э_БСП.ТекущийПользователь();
		УстановитьПривилегированныйРежим(Истина);
		МенеджерЗаписи.Записать(Истина);
		УстановитьПривилегированныйРежим(Ложь);
		Если ОписаниеРеквизита.ДополнительныеПараметры.Свойство("ДополнительноеСведение") Тогда
			УстановитьПривилегированныйРежим(Истина);
			А1Э_ДопРеквизиты.Установить(Объект.Ссылка, ОписаниеРеквизита.Имя, Значение, "ДС"); 
			УстановитьПривилегированныйРежим(Ложь);
		КонецЕсли;
	КонецФункции
	
	Функция Значение(Знач Ссылка, Знач КлючИлиИмя, Знач Дата = Неопределено) Экспорт
		Описание = ПолучитьОписание(КлючИлиИмя);
		Параметры = Новый Структура;
		Параметры.Вставить("Ссылка", Ссылка.Ссылка);
		Параметры.Вставить("Ключ", Описание.Ключ);
		Параметры.Вставить("Дата", ?(Дата = Неопределено, ТекущаяДата(), Дата));
		
		Результат = А1Э_Запросы.ПервыйРезультат(
		"ВЫБРАТЬ
		|	ПериодическийРеквизит.Значение КАК Значение
		|ИЗ
		|	РегистрСведений.А1_ПериодическиеРеквизиты.СрезПоследних(
		|			&Дата,
		|			Объект = &Ссылка
		|				И КлючРеквизита = &Ключ) КАК ПериодическийРеквизит",
		Параметры);
		Если Результат = Неопределено Тогда
			Возврат А1Э_СтандартныеТипы.ПустоеЗначение(Описание.ТипЗначения);
		Иначе
			Возврат Результат;
		КонецЕсли;
	КонецФункции 
#КонецЕсли

#Область ОписанияРеквизитов

Функция ПолучитьОписание(КлючИлиИмя, ПовторноеИспользование = Истина) Экспорт 
	Если ПовторноеИспользование = Истина Тогда
		Возврат А1Э_ПовторноеИспользование.РезультатФункции("А1Э_ПериодическиеРеквизиты.ПолучитьОписание", КлючИлиИмя, Ложь);
	КонецЕсли;
	Если ТипЗнч(КлючИлиИмя) = Тип("Число") Тогда
		Возврат ОписаниеПоКлючу(КлючИлиИмя);
	ИначеЕсли ТипЗнч(КлючИлиИмя) = Тип("Строка") Тогда
		Возврат ОписаниеПоИмени(КлючИлиИмя);
	Иначе
		А1Э_Служебный.ИсключениеНеверныйТип("КлючИлиИмя", "А1Э_ПериодическиеРеквизиты.ПолучитьОписание()", КлючИлиИмя, "Число,Строка");
	КонецЕсли;
КонецФункции 

Функция ОписаниеПоКлючу(Ключ, ПовторноеИспользование = Истина) Экспорт
	Если ПовторноеИспользование = Истина Тогда
		Возврат А1Э_ПовторноеИспользование.РезультатФункции("А1Э_ПериодическиеРеквизиты.ОписаниеПоКлючу", Ключ, Ложь);
	КонецЕсли;
	МассивОписаний = МассивОписаний();
	Возврат А1Э_ТаблицыЗначений.НайтиСтроку(МассивОписаний, "Ключ", Ключ);
КонецФункции 

Функция ОписаниеПоИмени(Имя, ПовторноеИспользование = Истина) Экспорт
	Если ПовторноеИспользование = Истина Тогда
		Возврат А1Э_ПовторноеИспользование.РезультатФункции("А1Э_ПериодическиеРеквизиты.ОписаниеПоИмени", Имя, Ложь);
	КонецЕсли;	
	МассивОписаний = МассивОписаний();
	Возврат А1Э_ТаблицыЗначений.НайтиСтроку(МассивОписаний, "Имя", Имя);
КонецФункции 

Функция МассивОписанийПоСсылке(Ссылка, ПовторноеИспользование = Истина) Экспорт
	Если ПовторноеИспользование = Истина Тогда
		Возврат А1Э_ПовторноеИспользование.РезультатФункции("А1Э_ПериодическиеРеквизиты.МассивОписанийПоСсылке", Ссылка, Ложь);
	КонецЕсли;	
	ТипПоиска = ТипЗнч(Ссылка);
	МассивОписаний = МассивОписаний();
	МассивОписанийОбъекта = Новый Массив;
	Для Каждого Описание Из МассивОписаний Цикл
		Если Описание.ТипОбъекта.СодержитТип(ТипПоиска) Тогда
			МассивОписанийОбъекта.Добавить(Описание);
		КонецЕсли;
	КонецЦикла;
	Возврат МассивОписанийОбъекта;	
КонецФункции 

Функция МассивОписаний(ПовторноеИспользование = Истина) Экспорт
	Если ПовторноеИспользование = Истина Тогда
		Возврат А1Э_ПовторноеИспользование.РезультатФункции("А1Э_ПериодическиеРеквизиты.МассивОписаний", Ложь);
	КонецЕсли;
	Если НЕ А1Э_ОбщееСервер.РезультатФункции("А1Э_Метаданные.ОбъектСуществует", "ОбщиеМодули", "А1_ПериодическиеРеквизиты") Тогда
		Возврат Новый Массив;
	КонецЕсли;
	Попытка
		МассивОписаний = Вычислить("А1_ПериодическиеРеквизиты.МассивОписаний()");
	Исключение
		ОписаниеОшибки = ОписаниеОшибки();
		Возврат Новый Массив;
	КонецПопытки;
	Для Каждого Описание Из МассивОписаний Цикл
		Описание.ТипОбъекта = А1Э_СтандартныеТипы.ОписаниеТиповПолучить(Описание.ТипОбъекта);
		Описание.ТипЗначения = А1Э_СтандартныеТипы.ОписаниеТиповПолучить(Описание.ТипЗначения);
		Если ТипЗнч(Описание.ДополнительныеПараметры) <> Тип("Структура") Тогда
			Описание.ДополнительныеПараметры = Новый Структура;
		КонецЕсли;
	КонецЦикла;
	Возврат МассивОписаний;	
КонецФункции 

Функция СоздатьОписание(Ключ, Имя, Заголовок, ТипОбъекта, ТипЗначения, ДополнительныеПараметры = Неопределено) Экспорт
	Описание = НовоеОписание();
	Описание.Ключ = Ключ;
	Описание.Имя = Имя;
	Описание.Заголовок = Заголовок;
	Описание.ТипОбъекта = ТипОбъекта;
	Описание.ТипЗначения = ТипЗначения;
	Описание.ДополнительныеПараметры = А1Э_Структуры.Структура(ДополнительныеПараметры);
	Возврат Описание;
КонецФункции 

Функция НовоеОписание()
	Структура = Новый Структура;
	Структура.Вставить("Класс", А1Э_Классы.ОписаниеПериодическогоРеквизита());
	Структура.Вставить("Ключ", 0); //Число(10,0) > 0. Является измерением регистра.
	Структура.Вставить("Имя", ""); //Строка, которая может быть ключом структуры
	Структура.Вставить("Заголовок", ""); //Строка 
	Структура.Вставить("ТипОбъекта", ""); //Строка - список типов через запятую или ОписаниеТипов. Доступны СправочникСсылка, ДокументСсылка. 
	Структура.Вставить("ТипЗначения", ""); //Строка - список типов через запятую или ОписаниеТипов. Доступны строка, число, дата, булево, ЛюбаяСсылка.
	Структура.Вставить("ДополнительныеПараметры", Неопределено); //Структура.
	Возврат Структура;
КонецФункции 

#КонецОбласти 

#Область Формы

#Область Обработчики_Сервер
#Если НЕ Клиент Тогда
	
	Функция ПриСозданииНаСервере(Форма, ГруппаФормыДляПериодическихРеквизитов) Экспорт 
		МассивОписанийПериодическихРеквизитов = МассивОписанийПоСсылке(Форма.Объект.Ссылка);
		Если МассивОписанийПериодическихРеквизитов.Количество() = 0 Тогда
			Возврат Неопределено;
		КонецЕсли;
		ТаблицаРеквизитов = Новый ТаблицаЗначений;
		ТаблицаРеквизитов.Колонки.Добавить("Имя", А1Э_Строки.ОписаниеТипа(100));
		ТаблицаРеквизитов.Колонки.Добавить("Ключ", А1Э_Числа.ОписаниеТипа(10));
		МассивОписанийОбъектовФормы = Новый Массив;
		Для Каждого Описание Из МассивОписанийПериодическихРеквизитов Цикл
			А1Э_Формы.ДобавитьОписаниеРеквизитаИЭлемента(МассивОписанийОбъектовФормы, ИмяРеквизитаФормы(Описание.Имя), Описание.ТипЗначения, , Описание.Заголовок, ГруппаФормыДляПериодическихРеквизитов,,Описание.ДополнительныеПараметры);
			А1Э_Формы.ДобавитьОписаниеРеквизита(МассивОписанийОбъектовФормы, ИмяРеквизитаИсходногоЗначенияФормы(Описание.Имя), Описание.ТипЗначения); 
			Параметры = Новый Структура("Тип,ОтображатьЗаголовок,Группировка", Тип("ГруппаФормы"), Ложь, ГруппировкаПодчиненныхЭлементовФормы.ГоризонтальнаяВсегда);
			А1Э_Формы.ДобавитьОписаниеЭлемента(МассивОписанийОбъектовФормы, ИмяГруппыКоманд(Описание.Имя), , , ГруппаФормыДляПериодическихРеквизитов, , Параметры);
			РодительКоманд = ИмяГруппыКоманд(Описание.Имя);
			А1Э_Формы.ДобавитьОписаниеКомандыИКнопки(МассивОписанийОбъектовФормы, ИмяКомандыЗаписиЗначения(Описание.Имя),
			"А1Э_ПериодическиеРеквизиты.КомандаЗаписиЗначения", Ложь, "Записать (" + Описание.Заголовок + ")", РодительКоманд); 
			А1Э_Формы.ДобавитьОписаниеКомандыИКнопки(МассивОписанийОбъектовФормы, ИмяКомандыИсторииИзменения(Описание.Имя),
			"А1Э_ПериодическиеРеквизиты.КомандаИсторииИзменения", Истина, "История изменений (" + Описание.Заголовок + ")", РодительКоманд);
			Строка = ТаблицаРеквизитов.Добавить();
			ЗаполнитьЗначенияСвойств(Строка, Описание);
		КонецЦикла;
		А1Э_УниверсальнаяФорма.ДобавитьРеквизитыИЭлементы(Форма, МассивОписанийОбъектовФормы);
		
		Если НЕ ЗначениеЗаполнено(Форма.Объект.Ссылка) Тогда
			Возврат Неопределено;
		КонецЕсли;
		Запрос = Новый Запрос(ТекстЗапросаЗаполненияИсходныхЗначений());
		Запрос.УстановитьПараметр("Ссылка", Форма.Объект.Ссылка);
		Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДата());
		Запрос.УстановитьПараметр("ТаблицаРеквизитов", ТаблицаРеквизитов);
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			Форма[ИмяРеквизитаФормы(Выборка.Имя)] = Выборка.Значение;
			Форма[ИмяРеквизитаИсходногоЗначенияФормы(Выборка.Имя)] = Выборка.Значение;
		КонецЦикла;
		
	КонецФункции
	
	Функция ТекстЗапросаЗаполненияИсходныхЗначений() Экспорт
		Текст = 
		"ВЫБРАТЬ
		|	ТаблицаРеквизитов.Имя КАК Имя,
		|	ТаблицаРеквизитов.Ключ КАК Ключ
		|ПОМЕСТИТЬ ТаблицаРеквизитов
		|ИЗ
		|	&ТаблицаРеквизитов КАК ТаблицаРеквизитов
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаРеквизитов.Имя КАК Имя,
		|	ТаблицаРеквизитов.Ключ КАК Ключ,
		|	ЕСТЬNULL(ПериодическиеРеквизиты.Значение, НЕОПРЕДЕЛЕНО) КАК Значение
		|ИЗ
		|	ТаблицаРеквизитов КАК ТаблицаРеквизитов
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.А1_ПериодическиеРеквизиты.СрезПоследних(&ТекущаяДата, ) КАК ПериодическиеРеквизиты
		|		ПО ТаблицаРеквизитов.Ключ = ПериодическиеРеквизиты.КлючРеквизита
		|			И (ПериодическиеРеквизиты.Объект = &Ссылка)";
		Возврат Текст;
	КонецФункции
	
	Функция ПриЗаписиНаСервере(Форма) Экспорт
		МассивОписанийПериодическихРеквизитов = МассивОписанийПоСсылке(Форма.Объект.Ссылка);
		Если МассивОписанийПериодическихРеквизитов.Количество() = 0 Тогда
			Возврат Неопределено;
		КонецЕсли;
		ТекущаяДата = ТекущаяДата();
		Пользователь = А1Э_БСП.ТекущийПользователь();
		Для Каждого Описание Из МассивОписанийПериодическихРеквизитов Цикл
			Если Форма[ИмяРеквизитаФормы(Описание.Имя)] = Форма[ИмяРеквизитаИсходногоЗначенияФормы(Описание.Имя)] Тогда
				Продолжить;
			КонецЕсли;
			УстановитьПривилегированныйРежим(Истина);
			А1Э_ПериодическиеРеквизиты.Установить(Форма.Объект.Ссылка, Описание.Ключ, Форма[ИмяРеквизитаФормы(Описание.Имя)]);
			УстановитьПривилегированныйРежим(Ложь);
		КонецЦикла;
	КонецФункции 
	
#КонецЕсли
#КонецОбласти

#Область Обработчики_Клиент
#Если Клиент Тогда
	
	Функция КомандаИсторииИзменения(Форма, Команда) Экспорт
		Если НЕ ЗначениеЗаполнено(Форма.Объект.Ссылка) Тогда
			Сообщить("У нового объекта нет истории периодических реквизитов");
			Возврат Неопределено;
		КонецЕсли;
		ДанныеКоманды = А1Э_Строки.Разделить(Команда.Имя, "___");
		ИмяРеквизита = ДанныеКоманды[1];
		ОписаниеРеквизита = ОписаниеПоИмени(ИмяРеквизита);
		СтруктураОтбора = Новый Структура("Объект,Ключ", Форма.Объект.Ссылка, ОписаниеРеквизита.Ключ);
		Параметры = Новый Структура("Отбор", Структураотбора);
		ИмяФормы = "РегистрСведений.А1_ПериодическиеРеквизиты.ФормаСписка";
		ОткрытьФорму(ИмяФормы, Параметры,,,,,,РежимОткрытияОкнаФормы.Независимый);  
	КонецФункции
	
	Функция КомандаЗаписиЗначения(Форма, Команда) Экспорт
		Если НЕ ЗначениеЗаполнено(Форма.Объект.Ссылка) Тогда
			Сообщить("Для записи значения необходимо записать текущий объект!");
			Возврат Неопределено;
		КонецЕсли;
		ДанныеКоманды = А1Э_Строки.Разделить(Команда.Имя, "___");
		ИмяРеквизита = ДанныеКоманды[1];
		ОписаниеРеквизита = ОписаниеПоИмени(ИмяРеквизита);
		Если Форма[ИмяРеквизитаФормы(ИмяРеквизита)] = Форма[ИмяРеквизитаИсходногоЗначенияФормы(ИмяРеквизита)] Тогда
			Возврат Неопределено;
		КонецЕсли;
		ПараметрыПроцедуры = А1Э_Массивы.Создать(Форма.Объект.Ссылка, ОписаниеРеквизита.Ключ, Форма[ИмяРеквизитаФормы(ИмяРеквизита)]);
		А1Э_ОбщееСервер.ВыполнитьПроцедуру("А1Э_ПериодическиеРеквизиты.Установить", ПараметрыПроцедуры);
		Форма[ИмяРеквизитаИсходногоЗначенияФормы(ИмяРеквизита)] = Форма[ИмяРеквизитаФормы(ИмяРеквизита)];
	КонецФункции 
	
#КонецЕсли
#КонецОбласти 

Функция ИмяРеквизитаФормы(Имя)
	Возврат "ПериодическийРеквизит___" + Имя;	
КонецФункции

Функция ИмяРеквизитаИсходногоЗначенияФормы(Имя)
	Возврат "ПериодическийРеквизитИсходноеЗначение___" + Имя;
КонецФункции

Функция ИмяКомандыИсторииИзменения(Имя)
	Возврат "ПериодическийРеквизитИсторияИзменений___" + Имя; 	
КонецФункции 

Функция ИмяГруппыКоманд(Имя)
	Возврат "ПериодическийРеквизитГруппаКоманд___" + Имя;	
КонецФункции

Функция ИмяКомандыЗаписиЗначения(Имя)
	Возврат "ПериодическийРеквизитЗаписатьЗначение___" + Имя;	
КонецФункции 

#КонецОбласти

#Область Служебно
#Если НЕ Клиент Тогда
	
	Функция ФормаСписка_ПриПолученииДанныхСписка(Строки) Экспорт 
		Для Каждого Строка Из Строки Цикл
			Строка.Значение.Данные["Реквизит"] = ОписаниеПоКлючу(Строка.Значение.Данные["Ключ"]).Заголовок;
		КонецЦикла;
	КонецФункции
	
	Функция ФормаСписка_ПриСозданииНаСервере(Форма) Экспорт
		Поля = А1Э_Массивы.Создать("Реквизит");
		Форма.Список.УстановитьОграниченияИспользованияВГруппировке(Поля);
		Форма.Список.УстановитьОграниченияИспользованияВПорядке(Поля);
		Форма.Список.УстановитьОграниченияИспользованияВОтборе(Поля);
	КонецФункции
	
	Функция НаборЗаписей_ПередЗаписью(НаборЗаписей, Отказ, Замещение) Экспорт
		Соответствие = Новый Соответствие;
		Если НаборЗаписей.Отбор.Объект.Использование = Истина Тогда
			Соответствие.Вставить(НаборЗаписей.Отбор.Объект.Значение);
		КонецЕсли;
		Для Каждого Запись Из НаборЗаписей Цикл
			Соответствие.Вставить(Запись.Объект);
		КонецЦикла;
		Для Каждого Пара Из Соответствие Цикл
			Если НЕ ПравоДоступа("Изменение", Пара.Ключ.Метаданные()) Тогда
				Отказ = Истина;
				А1Э_Сообщения.СообщитьПоШаблону("Не удалось изменить реквизит объекта [Объект] -  недостаточно прав доступа!",
				Новый Структура("Объект", Пара.Ключ));
			КонецЕсли;
		КонецЦикла;
		
	КонецФункции
	
#КонецЕсли
#КонецОбласти 