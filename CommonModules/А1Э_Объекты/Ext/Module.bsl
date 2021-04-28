﻿Функция Создать(ПолноеИмя) Экспорт
	ЧастиИмени = А1Э_Строки.ПередПосле(ПолноеИмя, ".");
	МенеджерТипа = А1Э_Метаданные.МенеджерТипаОбъектов(ЧастиИмени.Перед);
	Менеджер = МенеджерТипа[ЧастиИмени.После];
	Если ТипЗнч(МенеджерТипа) = Тип("СправочникиМенеджер") Тогда
		Возврат Менеджер.СоздатьЭлемент();
	ИначеЕсли ТипЗнч(МенеджерТипа) = Тип("ДокументыМенеджер") Тогда
		Возврат Менеджер.СоздатьДокумент();
	ИначеЕсли ТипЗнч(МенеджерТипа) = Тип("ЗадачиМенеджер") Тогда
		Возврат Менеджер.СоздатьЗадачу();
	КонецЕсли;
	А1Э_Служебный.СлужебноеИсключение("Не удалось создать объект!");
КонецФункции 

// Если УИД заполнен и существует в базе, то получает объект по УИД. Иначе создает новый объект и присваивает ему УИД.
//
// Параметры:
//  ПолноеИмя	 - Строка - например, <Справочник.Номенклатура> 
//  УИД			 - Строка, УникальныйИдентификатор - строка должна содержать 32 или 36 символов. 
// 
// Возвращаемое значение:
//   - 
//
Функция Получить(ПолноеИмя, Знач УИД = Неопределено) Экспорт
	Если НЕ ЗначениеЗаполнено(УИД) Тогда Возврат Создать(ПолноеИмя); КонецЕсли;
	
	УникальныйИдентификатор = А1Э_СтандартныеТипы.УИДПолучить(УИД);
		
	ЧастиИмени = А1Э_Строки.ПередПосле(ПолноеИмя, ".");
	МенеджерТипа = А1Э_Метаданные.МенеджерТипаОбъектов(ЧастиИмени.Перед);
	Менеджер = МенеджерТипа[ЧастиИмени.После];
	
	Ссылка = Менеджер.ПолучитьСсылку(УникальныйИдентификатор);
	Если СтрНачинаетсяС(Строка(Ссылка), "<Объект не найден>") Тогда //проверка на битую. ТУДУ: улучшить?
		Объект = Создать(ПолноеИмя);
		Объект.УстановитьСсылкуНового(Ссылка);
	Иначе
		Объект = Ссылка.ПолучитьОбъект();
	КонецЕсли;
	
	Возврат Объект;
КонецФункции

Функция Записать(Объект) Экспорт
	Если Объект.ОбменДанными.Загрузка = Истина Тогда
		Объект.Записать();
	ИначеЕсли А1Э_Общее.ЗначениеСвойства(Объект, "Проведен") = Истина Тогда
		Объект.Записать(РежимЗаписиДокумента.Проведение)
	Иначе
		Объект.Записать();
	КонецЕсли;
КонецФункции 

Функция Изменить(ОбъектИлиСсылка, К1 = Null, З1 = Null, К2 = Null, З2 = Null, К3 = Null, З3 = Null, К4 = Null, З4 = Null, К5 = Null, З5 = Null, К6 = Null, З6 = Null, К7 = Null, З7 = Null, К8 = Null, З8 = Null, К9 = Null, З9 = Null, К10 = Null, З10 = Null) Экспорт 
	Структура = А1Э_Структуры.Создать(К1, З1, К2, З2, К3, З3, К4, З4, К5, З5, К6, З6, К7, З7, К8, З8, К9, З9, К10, З10);
	Возврат ИзменитьПоСтруктуре(ОбъектИлиСсылка, Структура);
КонецФункции

Функция ИзменитьСПараметрами(ОбъектИлиСсылка, Параметры, К1 = Null, З1 = Null, К2 = Null, З2 = Null, К3 = Null, З3 = Null, К4 = Null, З4 = Null, К5 = Null, З5 = Null, К6 = Null, З6 = Null, К7 = Null, З7 = Null, К8 = Null, З8 = Null, К9 = Null, З9 = Null, К10 = Null, З10 = Null) Экспорт
	Структура = А1Э_Структуры.Создать(К1, З1, К2, З2, К3, З3, К4, З4, К5, З5, К6, З6, К7, З7, К8, З8, К9, З9, К10, З10);
	Возврат ИзменитьПоСтруктуре(ОбъектИлиСсылка, Структура, Параметры);
КонецФункции

Функция ИзменитьПоСтруктуре(ОбъектИлиСсылка, Структура, Параметры = Неопределено) Экспорт
	Если А1Э_СтандартныеТипы.ЭтоСсылка(ОбъектИлиСсылка) Тогда
		Объект = ОбъектИлиСсылка.ПолучитьОбъект();
		Записывать = Истина;
	Иначе
		Объект = ОбъектИлиСсылка;
		Записывать = Ложь;
	КонецЕсли;
	
	Если А1Э_Структуры.Свойство(Параметры, "ОбменДаннымиЗагрузка") Тогда Объект.ОбменДанными.Загрузка = Истина; КонецЕсли;
	ЗаполнитьЗначенияСвойств(Объект, Структура);
	
	Если Записывать Тогда
		Записать(Объект);
	КонецЕсли;
КонецФункции

Функция Выбрать(ПолноеИмя, Отбор = Неопределено) Экспорт
	Запрос = Новый Запрос( 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	*
	|ИЗ
	|	ПолноеИмяОбъекта КАК Таблица
	|ГДЕ
	|	&ТекстУсловийОтбора");
	Если ТипЗнч(Отбор) = Тип("Структура") Тогда
		УсловияОтбора = Новый Массив;
		Для Каждого Пара Из Отбор Цикл
			Если ТипЗнч(Пара.Значение) = Тип("Структура") Тогда
				Сравнение = Пара.Значение.Сравнение;
				Значение = Пара.Значение.Значение;
			ИначеЕсли ТипЗнч(Пара.Значение) = Тип("Массив") Тогда
				Сравнение = "В";
				Значение = Пара.Значение;
			Иначе
				Сравнение = "=";
				Значение = Пара.Значение;
			КонецЕсли;
			УсловияОтбора.Добавить("Таблица." + Пара.Ключ + " " + Сравнение + " (&Значение_" + Пара.Ключ + ")");
			Запрос.УстановитьПараметр("Значение_" + Пара.Ключ, Значение);
		КонецЦикла;
		ТекстУсловийОтбора = СтрСоединить(УсловияОтбора, Символы.ПС + "И ");
	Иначе
		ТекстУсловийОтбора = "ИСТИНА";
	КонецЕсли;
	А1Э_Строки.Подставить(Запрос.Текст, "&ТекстУсловийОтбора", ТекстУсловийОтбора);
	А1Э_Строки.Подставить(Запрос.Текст, "ПолноеИмяОбъекта", ПолноеИмя);
	Возврат Запрос.Выполнить().Выбрать();
КонецФункции

// Создает копию объекта (очищает номер/код). Используется когда нажна строгая копия (без обработчиков копирования).
//
// Параметры:
//  ОбъектИлиСсылка	 - Объект, Ссылка - источник данных для копирования.
//  ОбъектПриемник	 - Объект, Неопределено - если Неопределено - будет создан новый объект. Иначе данные будут скопированы в переданный.
//  Исключения - Массив, Строка - эти поля не будут клонированы. Разрешается передача колонки ТЧ через ".", например "Товары.Номенклатура".
// Возвращаемое значение:
//   - 
//
Функция Клонировать(Знач ОбъектИлиСсылка, Знач ОбъектПриемник = Неопределено, Знач Исключения = Неопределено) Экспорт
	Если ТипЗнч(ОбъектИлиСсылка) = Тип("ДанныеФормыСтруктура") Тогда
		ОбъектИлиСсылка = ОбъектИлиСсылка.Ссылка;
	КонецЕсли;
	МетаданныеОбъекта = ОбъектИлиСсылка.Метаданные();
	Если ОбъектПриемник = Неопределено Тогда
		ОбъектПриемник = Создать(МетаданныеОбъекта.ПолноеИмя());
	КонецЕсли;
	ТипМетаданных = А1Э_Метаданные.ТипМетаданных(МетаданныеОбъекта);
	МассивИсключений = Новый Массив; // Содержит исключения полей.
	ИсключенияТЧ = Новый Структура; // Содержит исключения колонок.

	Если ТипМетаданных = "Справочник" И	А1Э_Общее.Свойство(ОбъектПриемник, "Код") Тогда
		МассивИсключений.Добавить("Код");
	ИначеЕсли ТипМетаданных = "Документ" И А1Э_Общее.Свойство(ОбъектПриемник, "Номер") Тогда
		МассивИсключений.Добавить("Номер");
	КонецЕсли;
	
	Если Исключения <> Неопределено Тогда
		ИсходныйМассивИсключений = А1Э_Массивы.Массив(Исключения);
		Для Каждого Элемент Из ИсходныйМассивИсключений Цикл
			ЧастиСтроки = А1Э_Строки.ПередПосле(Элемент, ".");
			Если ЗначениеЗаполнено(ЧастиСтроки.После) Тогда
				Если НЕ ИсключенияТЧ.Свойство(ЧастиСтроки.Перед) Тогда
					ИсключенияТЧ.Вставить(ЧастиСтроки.Перед, Новый Массив);
				КонецЕсли;
				ИсключенияТЧ[ЧастиСтроки.Перед].Добавить(ЧастиСтроки.После);
			Иначе
				МассивИсключений.Добавить(ЧастиСтроки.Перед);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ОбъектПриемник, ОбъектИлиСсылка, , СтрСоединить(МассивИсключений, ","));
	
	Для Каждого ТабличнаяЧасть Из МетаданныеОбъекта.ТабличныеЧасти Цикл
		КлонироватьТЧ(ОбъектПриемник, ОбъектИлиСсылка, ТабличнаяЧасть.Имя, А1Э_Структуры.ЗначениеСвойства(ИсключенияТЧ, ТабличнаяЧасть.Имя));  
	КонецЦикла;
	
	Возврат ОбъектПриемник;
КонецФункции

Функция КлонироватьТЧ(ОбъектПриемник, Источник, ИмяТЧ, Знач Исключения = Неопределено) Экспорт
	ТЧИсточник = Источник[ИмяТЧ];
	ТЧПриемник = ОбъектПриемник[ИмяТЧ];

	Если НЕ ЗначениеЗаполнено(Исключения) Тогда
		ТЧПриемник.Загрузить(ТЧИсточник.Выгрузить());
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(Исключения) = Тип("Массив") Тогда
		ИсключенияСтрока = СтрСоединить(Исключения);
	Иначе
		ИсключенияСтрока = Исключения;
	КонецЕсли;

	Для Сч = 0 По ТЧИсточник.Количество() - 1 Цикл
		СтрокаИсточник = ТЧИсточник[Сч];
		Если Сч >= ТЧПриемник.Количество() Тогда
			СтрокаПриемник = ТЧПриемник.Добавить();
		Иначе
			СтрокаПриемник = ТЧПриемник[Сч];
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(СтрокаПриемник, СтрокаИсточник, , ИсключенияСтрока);
	КонецЦикла;
	
	Пока ТЧПриемник.Количество() > ТЧИсточник.Количество() Цикл
		ТЧПриемник.Удалить(ТЧИсточник.Количество());
	КонецЦикла;
КонецФункции

// Обычно взводит отказ и сообщает причину. В режиме отладки вызывает исключение.
//
// Параметры:
//  Объект	 - ЛюбойОбъект -  
//  Отказ	 - Булево	 - 
//  Причина	 - 	 - 
// 
// Возвращаемое значение:
//   - 
//
Функция УстановитьОтказ(Объект, Отказ, Причина) Экспорт
	МодульБСП = А1Э_Метаданные.ОбщийМодуль("ОбщегоНазначенияКлиентСервер");
	Если МодульБСП = Неопределено Тогда
		РежимОтладки = Ложь;
	Иначе
		РежимОтладки = МодульБСП.РежимОтладки();
	КонецЕсли;
	Сообщить(Причина);
	Отказ = Истина;
	Если РежимОтладки = Истина Тогда
		Если А1Э_Общее.Свойство(Объект, "Ссылка") Тогда
			Представление = "" + Объект.Ссылка;
		Иначе
			Представление = Объект.Метаданные().ПолноеИмя();
		КонецЕсли;
		
		ВызватьИсключение "Не удалось записать " + Представление;
	КонецЕсли;
КонецФункции

Функция МассивПолей(Объект) Экспорт
	МетаданныеОбъекта = Объект.Метаданные();
	ТипМетаданных = А1Э_Метаданные.ТипМетаданных(МетаданныеОбъекта);
	МассивПолей = Новый Массив;
	МассивПолей.Добавить("ПометкаУдаления");
	Если ТипМетаданных = "Справочник" Тогда
		Если МетаданныеОбъекта.ДлинаКода > 0 Тогда
			МассивПолей.Добавить("Код");
		КонецЕсли;
		Если МетаданныеОбъекта.ДлинаНаименования > 0 Тогда
			МассивПолей.Добавить("Наименование");
		КонецЕсли;
	ИначеЕсли ТипМетаданных = "Документ" Тогда
		МассивПолей.Добавить("Дата");
		Если МетаданныеОбъекта.ДлинаНомера > 0 Тогда
			МассивПолей.Добавить("Номер");
		КонецЕсли;
		Если МетаданныеОбъекта.Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить Тогда
			МассивПолей.Добавить("Проведен");
		КонецЕсли;
	КонецЕсли;
	Для Каждого Реквизит Из МетаданныеОбъекта.Реквизиты Цикл
		МассивПолей.Добавить(Реквизит.Имя);
	КонецЦикла;
	//ТУДУ: Добавить общие реквизиты.
	Возврат МассивПолей;
КонецФункции

Функция МассивПолейТЧ(Объект, ИмяТЧ) Экспорт
	Результат = Новый Массив;
	ТЧ = Объект.Метаданные().ТабличныеЧасти[ИмяТЧ];
	Для Каждого Поле из ТЧ.Реквизиты Цикл
		Результат.Добавить(Поле.Имя);
	КонецЦикла;
	Возврат Результат;
КонецФункции 

Функция Объект(ОбъектИлиФорма) Экспорт
	Если ТипЗнч(ОбъектИлиФорма) = А1Э_СтандартныеТипы.ФормаКлиентскогоПриложения() Тогда
		Возврат ОбъектИлиФорма.Объект;
	КонецЕсли;
	Возврат ОбъектИлиФорма;
КонецФункции

#Область РаботаСИзменениями

Функция ОбъектИзменен(Объект) Экспорт
	Возврат Объект.ДополнительныеСвойства.А1Э_СписокИзменений.Количество() > 0;
КонецФункции

Функция ОбъектИзмененКроме(Объект, Знач ИменаПолей) Экспорт 
	ИменаПолей = А1Э_Массивы.Массив(ИменаПолей);
	ПолныеПоля = Новый Структура;
	КолонкиТЧ = Новый Структура;
	Для Каждого ИмяПоля Из ИменаПолей Цикл
		ЧастиСтроки = А1Э_Строки.ПередПосле(ИмяПоля, ".");
		ИмяРеквизитаИлиТЧ = ЧастиСтроки.Перед;
		ИмяКолонкиТЧ = ЧастиСтроки.После;
		Если ЗначениеЗаполнено(ИмяКолонкиТЧ) Тогда
			Если Не КолонкиТЧ.Свойство(ИмяРеквизитаИлиТЧ) Тогда
				КолонкиТЧ.Вставить(ИмяРеквизитаИлиТЧ, Новый Структура);
			КонецЕсли;
			КолонкиТЧ[ИмяРеквизитаИлиТЧ].Вставить(ИмяКолонкиТЧ, Неопределено);
		Иначе
			ПолныеПоля.Вставить(ИмяРеквизитаИлиТЧ, Неопределено);
		КонецЕсли;	
	КонецЦикла;
	
	Для Каждого Пара Из Объект.ДополнительныеСвойства.А1Э_СписокИзменений Цикл
		Если ПолныеПоля.Свойство(Пара.Ключ) Тогда Продолжить; КонецЕсли;
		Если НЕ КолонкиТЧ.Свойство(Пара.Ключ) Тогда
			Возврат Истина;
		КонецЕсли;
		ИсключенияТЧ = КолонкиТЧ[Пара.Ключ];
		Для Каждого ПараСтроки Из Пара.Значение Цикл
			Для Каждого ПараРеквизит Из ПараСтроки.Значение Цикл
				Если НЕ ИсключенияТЧ.Свойство(ПараРеквизит.Ключ) Тогда
					Возврат Истина;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	Возврат Ложь;
КонецФункции

Функция ПолеИзменено(Объект, Знач ИмяПоля) Экспорт
	//ТУДУ - сделать обработку ошибки.
	ЧастиСтроки = А1Э_Строки.ПередПосле(ИмяПоля, ".");
	ИмяРеквизитаИлиТЧ = ЧастиСтроки.Перед;
	ИмяКолонкиТЧ = ЧастиСтроки.После;
	Если НЕ ЗначениеЗаполнено(ИмяКолонкиТЧ) Тогда
		Возврат Объект.ДополнительныеСвойства.А1Э_СписокИзменений.Свойство(ИмяРеквизитаИлиТЧ);
	Иначе
		Если НЕ Объект.ДополнительныеСвойства.А1Э_СписокИзменений.Свойство(ИмяРеквизитаИлиТЧ) Тогда Возврат Ложь; КонецЕсли;
		Для Каждого Пара Из Объект.ДополнительныеСвойства.А1Э_СписокИзменений[ИмяРеквизитаИлиТЧ] Цикл
			Если Пара.Значение.Свойство(ИмяКолонкиТЧ) Тогда
				Возврат Истина;
			КонецЕсли;
		КонецЦикла;
		Возврат Ложь;
	КонецЕсли;
КонецФункции 

Функция ОдноИзПолейИзменено(Объект, Знач ИменаПолей) Экспорт
	ИменаПолей = А1Э_Массивы.Массив(ИменаПолей);
	Для Каждого ИмяПоля Из ИменаПолей Цикл
		Если ПолеИзменено(Объект, ИмяПоля) Тогда Возврат Истина; КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
КонецФункции

Функция СтароеЗначение(Объект, ИмяПоля) Экспорт 
	Если НЕ Объект.ДополнительныеСвойства.А1Э_СписокИзменений.Свойство(ИмяПоля) Тогда
		Возврат Объект[ИмяПоля];
	КонецЕсли;
	Возврат Объект.ДополнительныеСвойства.А1Э_СписокИзменений[ИмяПоля].СтароеЗначение; 
КонецФункции

#КонецОбласти 