
Перем юТест;

Перем СервераОблачнойКафки;
Перем ПользовательОблачнойКафки;
Перем ПарольОблачнойКафки;

////////////////////////////////////////////////////////////////////
// Программный интерфейс

Функция ПолучитьСписокТестов(ЮнитТестирование) Экспорт
	
	юТест = ЮнитТестирование;
	
	ВсеТесты = Новый Массив;

	СИ = Новый СистемнаяИнформация();
	// https://customer.cloudkarafka.com/instance
	СервераОблачнойКафки = СИ.ПолучитьПеременнуюСреды("CLOUDKARAFKA_BROKERS");
	ПользовательОблачнойКафки = СИ.ПолучитьПеременнуюСреды("CLOUDKARAFKA_USERNAME");
	ПарольОблачнойКафки = СИ.ПолучитьПеременнуюСреды("CLOUDKARAFKA_PASSWORD");

//	ВсеТесты.Добавить("ТестДолжен_ПроверитьСозданиеОбъектаИсточника");
//	ВсеТесты.Добавить("ТестДолжен_ПроверитьЗначениеСвойствПоУмолчаниюИсточника");
//	ВсеТесты.Добавить("ТестДолжен_ПроверитьОтправкуСообщения");
//	ВсеТесты.Добавить("ТестДолжен_ПроверитьОтправку100СообщенийСоСжатием");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьПолучениеСообщения");

	СервераОблачнойКафки = "";
	
	ПользовательОблачнойКафки = "";
	ПарольОблачнойКафки = "";
	
	Возврат ВсеТесты;
	
КонецФункции


Процедура ТестДолжен_ПроверитьСозданиеОбъектаИсточника() Экспорт

	
	Кафка = Новый КафкаКлиент();

	СписокСерверовСтрокой = СервераОблачнойКафки;

	Источник = Кафка.СоздатьИсточник(СписокСерверовСтрокой);

КонецПроцедуры

Процедура ТестДолжен_ПроверитьЗначениеСвойствПоУмолчаниюИсточника() Экспорт

	Кафка = Новый КафкаКлиент();

	СписокСерверовСтрокой = СервераОблачнойКафки;

	// время всегда в миллисекундах
	// размеры всегда в байтах

	Источник = Кафка.СоздатьИсточник(СписокСерверовСтрокой);
	
	Функциональность = "gzip, snappy, ssl, sasl, regex, lz4, sasl_gssapi, sasl_plain, sasl_scram, plugins";
	юТест.ПроверитьРавенство(Источник.ВстроеннаяФункциональность, Функциональность);

	юТест.ПроверитьРавенство(Источник.ИдентификаторКлиента, "vanessakafka");
	юТест.ПроверитьРавенство(Источник.МаксимальныйРазмерСообщенияПриЗапросе, 1000000);
	юТест.ПроверитьРавенство(Источник.МаксимальныйРазмерБуфераКопирования, 65535);
	юТест.ПроверитьРавенство(Источник.МаксимальныйРазмерСообщенияПриОтвете, 100000000);
	юТест.ПроверитьРавенство(
		Источник.МаксимальныйРазмерЗапросовОбрабатываемыхСоединениемНаЛету, 1000000);
	
	юТест.ПроверитьРавенство(Источник.ТаймаутЗапросаМетаданных, 60000);
	юТест.ПроверитьРавенство(Источник.ИнтервалОбновленияМетаданныхТемы, 300000);

	юТест.ПроверитьРавенство(Источник.ВремяЖизниКешаМетаданных, Источник.ИнтервалОбновленияМетаданныхТемы * 3);

	юТест.ПроверитьРавенство(Источник.ИнтервалОбновленияМетаданныхПриПереключенииСерверов, 250);
	юТест.ПроверитьРавенство(Источник.РазрешитьЗапросМетаданных, Истина);

	юТест.ПроверитьРавенство(Источник.ТаймаутСетевыхЗапросов, 60000);

	юТест.ПроверитьРавенство(Источник.РазмерБуфераОтправкиСетевогоСоединения, 0);
	юТест.ПроверитьРавенство(Источник.РазмерБуфераПолученияСетевогоСоединения, 0);

	юТест.ПроверитьРавенство(Источник.ПоддерживатьСоединениеОткрытым, Ложь);
	юТест.ПроверитьРавенство(Источник.ОтключитьАлгоритмНейгла, Ложь);
	юТест.ПроверитьРавенство(Источник.МаксимальноеКоличествоОшибокПередПереподключениемСоединения, 1);

	юТест.ПроверитьРавенство(Источник.ВремяЖизниКешаАдресовСерверов, 1000);

	юТест.ПроверитьРавенство(Источник.ТипАдресаСервера, "any");

	//https://habr.com/post/227225/
	юТест.ПроверитьРавенство(Источник.ВремяЗадержкиПриПереподключении, 500);
	юТест.ПроверитьРавенство(Источник.ИнтервалПолученияСтатистики, 0);

	юТест.ПроверитьРавенство(Источник.ВключитьБитовуюМаскуСобытий, 0);

	юТест.ПроверитьРавенство(Источник.ВключитьБитовуюМаскуСобытий, 0);

	юТест.ПроверитьРавенство(Источник.УровеньЖурналирования, 6);

	юТест.ПроверитьРавенство(Источник.ИспользоватьЖУрналированиеВОчередь, Ложь);
	юТест.ПроверитьРавенство(Источник.ВыводитьВЖурналИмяВнутреннегоПотоков, Истина);

	юТест.ПроверитьРавенство(Источник.ЖурналироватьЗакрытиеСоединений, Истина);
	юТест.ПроверитьРавенство(Источник.СигналБитПринудительногоУничтожения, 0);

	юТест.ПроверитьРавенство(Источник.ПередаватьВерсиюПротоколаСерверу, Истина);
	юТест.ПроверитьРавенство(Источник.ВремяДоПовторногоЗапросаВерсииСервера, 100);
	юТест.ПроверитьРавенство(Источник.ТаймаутПередачиВерсииПротокола, 10000);
	юТест.ПроверитьРавенство(Источник.ВремяДействияАварийнойВерсииПротокола, 1200000);
	юТест.ПроверитьРавенство(Источник.АварийнаяВерсияПротокола, "0.9.0");
	
	
	юТест.ПроверитьРавенство(Источник.ПротоколЗащиты, "plaintext");

	// https://ru.wikipedia.org/wiki/GSS-API
	юТест.ПроверитьРавенство(Источник.МеханизмСервисаБезопасности, "GSSAPI");

	//sasl.kerberos.service.name TODO - нужно во втором подходе проверить Kerberos аутентификацию
	// TODO - вообще всю
	// на самом деле очень удобно было бы использовать имя службы USRV81C
	
	юТест.ПроверитьРавенство(Источник.СтратегияНазначенияРаздела, "range,roundrobin");

	юТест.ПроверитьРавенство(Источник.СтратегияНазначенияРаздела, "range,roundrobin");
	юТест.ПроверитьРавенство(Источник.ТаймаутСессии, 30000);

	юТест.ПроверитьРавенство(Источник.ЧастотаПульса, 1000);

	юТест.ПроверитьРавенство(Источник.ТипГруппировкиВПротоколе, "consumer");
	юТест.ПроверитьРавенство(Источник.ИнтервалЗапросовКоординатораГруппы, 600000);

	юТест.ПроверитьРавенство(Источник.МаксимальноеКоличествоСообщенийВБуфереОчереди, 100000);
	юТест.ПроверитьРавенство(Источник.МаксимальныйРазмерСообщенийВБуфереОчереди, 1048576);

	юТест.ПроверитьРавенство(Источник.ЗадержкаПередОтправкойБуфера, 0);

	юТест.ПроверитьРавенство(Источник.КоличествоПовторовОтправкиСообщений, 2);
	
	юТест.ПроверитьРавенство(Источник.ПорогКоличествоЗапросовВБуфере, 1);
	юТест.ПроверитьРавенство(Источник.АлгоритмКомпрессии, "none");

	юТест.ПроверитьРавенство(Источник.МаксимальноеКоличествоСообщенийВНабореСообщений, 10000);

	юТест.ПроверитьРавенство(Источник.ИспользоватьОтчетОДоставкеТолькоДляОшибок, Ложь);

	// Свойства только для темы (топика)
	// https://github.com/edenhill/librdkafka/blob/master/CONFIGURATION.md#topic-configuration-properties

	// -1 = from-all, 0 - from-no-one, 1 - from-leader
	юТест.ПроверитьРавенство(Источник.ТипОжиданияПодтвержденияОтСервера, 1);
	юТест.ПроверитьРавенство(Источник.ТаймаутОжиданияПодтвержденияОтСервера, 5000);
	
	юТест.ПроверитьРавенство(Источник.ТаймаутОжиданияОтчетаОДоставке, 300000);

	юТест.ПроверитьРавенство(Источник.СтратегияОчередности, "fifo");

	юТест.ПроверитьРавенство(Источник.ВключатьВОтчетСмещениеНаСервере, Ложь);
	юТест.ПроверитьРавенство(Источник.СтратегияРазделения, "consistent_random");

	// для каждой темы можно выбрать свой формат сжатия
	// по умолчанию наследуется из объекта Источник
	юТест.ПроверитьРавенство(Источник.АлгоритмКомпрессииТемы, "inherit");
	юТест.ПроверитьРавенство(Источник.УровеньКомпрессииТемы, -1); // от -1 до 12


КонецПроцедуры

Процедура ТестДолжен_ПроверитьОтправкуСообщения() Экспорт
	
	
	Кафка = Новый КафкаКлиент();

	СписокСерверовСтрокой = СервераОблачнойКафки;

	Источник = Кафка.СоздатьИсточник(СписокСерверовСтрокой);
	
	Источник.ПодключитьсяСБезопаснымМетодомАутентификации(
		ПользовательОблачнойКафки, ПарольОблачнойКафки);

	// топик - ключ сообщения и сообщение
	Источник.ОтправитьСообщениеСинхронно("2r5y0tbx-main", "сообщение", "привет Кафка");

КонецПроцедуры

Процедура ТестДолжен_ПроверитьОтправку100СообщенийСоСжатием() Экспорт
	
	Кафка = Новый КафкаКлиент();

	СписокСерверовСтрокой = СервераОблачнойКафки;

	Источник = Кафка.СоздатьИсточник(СписокСерверовСтрокой);
	
	Источник.ПодключитьсяСБезопаснымМетодомАутентификации(
		ПользовательОблачнойКафки, ПарольОблачнойКафки);
		
	Источник.УстановитьСжатие("lz4");

	Для сч = 1 по 1000 Цикл
		Источник.ОтправитьСообщениеСинхронно("2r5y0tbx-main", "сообщение", "привет Кафка " + сч);
	КонецЦикла;

КонецПроцедуры

Процедура ТестДолжен_ПроверитьПолучениеСообщения() Экспорт

	Кафка = Новый КафкаКлиент();

	Подписчик = Кафка.СоздатьПодписчика("localhost:9092");
	Подписчик.Подписаться(
		"oscript-console-consumer",
		"onec.loan-added.events"
	);
	СообщениеВПотоке = Подписчик.ПолучитьСообщение();
	
КонецПроцедуры
