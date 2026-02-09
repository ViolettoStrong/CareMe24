import 'package:careme24/pages/dangerous/recomendation_page.dart';
import 'package:careme24/theme/dangerous_colors.dart';
import 'package:flutter/material.dart';

int getDangerIndex(String text) {
  switch (text) {
    case 'очень опасно':
    case 'Опасный':
      return 5;
    case 'опасно':
      return 4;
    case 'средний':
    case 'Повышенный':
      return 3;
    case 'в норме':
      return 1;
    default:
      return 0;
  }
}

int getTempIndex(int value) {
  if (value >= 25) {
    return 3;
  } else if (value >= 5 && value < 25) {
    return 2; // Средне высокая температура
  } else if (value >= -10 && value <= 4) {
    return 1; // Средняя температура
  } else if (value >= -25 && value <= -11) {
    return 4; // Низкая температура
  } else if (value <= -26) {
    return 5; // Низкая температура
  } else {
    return 0;
  }
}

int getPressureIndex(int pressure) {
  if (pressure >= 1040) {
    return 5;
  } else if (pressure >= 1020 && pressure < 1040) {
    return 3;
  } else if (pressure >= 1000 && pressure < 1020) {
    return 1; //
  } else if (pressure >= 950 && pressure < 1000) {
    return 3;
  } else {
    return 5;
  }
}

int getSpeedIndex(num speed) {
  if (speed > 36) {
    return 5;
  } else if (speed > 18 && speed <= 35) {
    return 3;
  } else {
    return 1;
  }
}

LinearGradient getGradient(String text) {
  switch (text) {
    case 'очень опасно':
    case 'Опасный':
      return DangerousColors.red;
    case 'опасно':
      return DangerousColors.darkYellow;
    case 'в норме':
      return DangerousColors.green;
    case 'средний':
    case 'Повышенный':
      return DangerousColors.yellow;
    default:
      return DangerousColors.grey;
  }
}

String getIcon(String value) {
  switch (value) {
    case 'Электромагнитное излучение': //!
      return 'assets/images/img_electromagnetic_radiation.svg';
    case 'Радиактивный фон': //!
      return 'assets/images/img_radiation.svg';
    case 'Торнадо смерч': //!
      return 'assets/images/img_tornado.svg';
    case 'Солнечная радиация': //!
      return 'assets/images/img_solar_radiation.svg';
    case 'Аллерген': //!
      return 'assets/images/allergen.svg';
    case 'Пожар': //!
      return 'assets/images/forestFire.svg';
    case 'Террористическая опасность': //!
      return 'assets/images/img_terrorist_danger.svg';
    case 'Воздушная тревога': //!
      return 'assets/images/img_air_warning.svg';
    case 'Землятрясение': //!
      return 'assets/images/img_earthquake.svg';
    case 'Наводнение': //!
      return 'assets/images/img_flood.svg';
    case 'Цунами': //!
      return 'assets/images/img_tsunami.svg';
    case 'Химическое заражение': //!
      return 'assets/images/1.svg';
    case 'Вирусное / бактериологическое заражение': //!
      return 'assets/images/virus.svg';
    case 'Гололёд':
      return 'assets/images/22n.svg';
    case 'Сильный туман': //!
      return 'assets/images/img_fog.svg';
    case 'Снежная лавина': //!
      return 'assets/images/img_snow_avalanche.svg';
    case 'Камнепад / Оползень': //!
      return 'assets/images/img_rockfall.svg';
    case 'Извержение вулкана': //!
      return 'assets/images/img_volcano.svg';
    case 'Крупный град': //!
      return 'assets/images/2.svg';
    default:
      return 'assets/images/default_icon.svg';
  }
}

List getRec(String value) {
  switch (value) {
    case 'Электромагнитное излучение':
      return [
        Recomendation(
            imagePath: 'assets/images/1.png',
            text:
                'Не стоит заряжать мобильный телефон вблизи головы во время сна'),
        Recomendation(
            imagePath: 'assets/images/2.png',
            text:
                'Проследите, чтобы места длительного пребывания человека не находились в зоне действия электромагнитных полей от микроволновки, плиты, холодильника, компьютера, большого скопления проводов.'),
      ];

    case 'Торнадо смерч':
      return [
        Recomendation(
            imagePath: 'assets/images/3.png',
            text:
                'Если ураган (буря, смерч) застал Вас в здании, отойдите от окон и займите безопасное место во внутренних комнатах дома'),
        Recomendation(
            imagePath: 'assets/images/4.png',
            text:
                'Погасите огонь в печах, отключите электроэнергию, закройте краны на газовых сетях'),
        Recomendation(
            imagePath: 'assets/images/5.png',
            text: 'В темное время суток используйте фонари, лампы, свечи'),
        Recomendation(
            imagePath: 'assets/images/6.png',
            text:
                'Включите радиоприемник для получения информации комиссии по чрезвычайным ситуациям;'),
        Recomendation(
            imagePath: 'assets/images/7.png',
            text:
                'Если смерч застает Вас на открытой местности, укрывайтесь на дне дорожного кювета, в ямах, рвах, узких оврагах, плотно прижимаясь к земле, закрыв голову одеждой или ветками деревьев. Не оставайтесь в автомобиле, выходите из него и укрывайтесь, как указано выше'),
      ];
    case 'Воздушная тревога':
      return [
        Recomendation(
            imagePath: 'assets/images/8.png',
            text:
                'Если вы находитесь дома, необходимо взять с собой личные документы, средства индивидуальной защиты, запас воды и продовольствия, отключить электроэнергию, воду, газ, плотно закрыть окна, форточки, вентиляционные устройства, принять меры по защите продуктов, воды и пищи от заражения, убыть в убежище'),
        Recomendation(
            imagePath: 'assets/images/9.png',
            text:
                'Если сигнал тревоги застал вас на рабочем месте, немедленно прекратите работать с безаварийной остановкой оборудования и переводом процессов непрерывного цикла в безопасный режим работы с последующим убытием в укрытие'),
        Recomendation(
            imagePath: 'assets/images/10.png',
            text:
                'В городском транспорте необходимо выйти из транспорта в месте его остановки и действовать по указанию постов гражданской обороны (ГО), полиции, водителей'),
        Recomendation(
            imagePath: 'assets/images/11.png',
            text:
                'Во всех случаях укрыться в ближайшем укрытии, а при его отсутствии использовать овраги, насыпи, ямы.'),
      ];
    case 'Снежная лавина':
      return [
        Recomendation(
            imagePath: 'assets/images/12.png',
            text:
                'Если вы оказались вне зоны схода лавины, сообщите любыми способами о происшедшем в администрацию ближайшего населенного пункта и приступайте к поиску и спасению пострадавших'),
        Recomendation(
            imagePath: 'assets/images/13.png',
            text:
                'Выбравшись из-под снега самостоятельно или с помощью спасателей, осмотрите свое тело и при необходимости окажите себе помощь'),
        Recomendation(
            imagePath: 'assets/images/14.png',
            text:
                'Добравшись до ближайшего населенного пункта, сообщите о происшедшем в местную администрацию'),
        Recomendation(
            imagePath: 'assets/images/15.png',
            text:
                'Обратитесь в медпункт или к врачу, даже если считаете, что здоровы'),
        Recomendation(
            imagePath: 'assets/images/16.png',
            text:
                'Сообщите своим родным и близким о своем состоянии и местонахождении'),
      ];
    case 'Террористическая опасность':
      return [
        Recomendation(
            imagePath: 'assets/images/17.png',
            text:
                'Всегда контролируйте ситуацию вокруг себя, особенно, когда находитесь на объектах транспорта, культурно-развлекательных, спортивных и торговых центрах'),
        Recomendation(
            imagePath: 'assets/images/18.png',
            text:
                'При обнаружении забытых вещей, не трогая их, сообщите об этом водителю, сотрудникам объекта, службы безопасности, органов полиции'),
        Recomendation(
            imagePath: 'assets/images/19.png',
            text:
                'Не подбирайте бесхозных вещей. В них могут быть закамуфлированы взрывные устройства (в банках из-под пива, сотовых телефонах и т.п.)'),
        Recomendation(
            imagePath: 'assets/images/20.png',
            text:
                'Если вдруг началась активизация сил безопасности и правоохранительных органов, идите в другую сторону, но не бегом, чтобы Вас не приняли за противника'),
        Recomendation(
            imagePath: 'assets/images/21.png',
            text:
                'При взрыве или начале стрельбы немедленно падайте на землю, лучше под прикрытие (бордюр, торговую палатку, машину и т.п.). Для большей безопасности накройте голову руками.'),
        Recomendation(
            imagePath: 'assets/images/22.png',
            text:
                'Случайно узнав о готовящемся теракте, немедленно сообщите об этом в правоохранительные органы'),
        Recomendation(
            imagePath: 'assets/images/23.png',
            text:
                'Если вам стало известно о готовящемся или совершенном преступлении, немедленно сообщите об этом в органы ФСБ или МВД.'),
      ];
    case 'Крупный град':
      return [
        Recomendation(
            imagePath: 'assets/images/24.png',
            text:
                'Ни в коем случае не выходите на улицу, закройте все окна и держитесь от них подальше. Не пользуйтесь электроприборами, так как град может сопровождаться электрическим разрядом молнии.'),
        Recomendation(
            imagePath: 'assets/images/25.png',
            text: 'Постарайтесь найти себе надежное укрытие.'),
        Recomendation(
            imagePath: 'assets/images/26.png',
            text:
                'Не пытайтесь найти укрытие под деревьями, так как велик риск не только попадания в них молний, но и того, что крупные градины и шквалистый ветер могут ломать ветви деревьев, что может нанести вам дополнительные повреждения.'),
        Recomendation(
            imagePath: 'assets/images/27.png',
            text:
                'Ни в коем случае не покидайте во время града автомобиль! Держитесь дальше от стекол, желательно развернуться к ним спиной, лицом к центру салона и прикрыть глаза руками или одеждой. Если с Вами оказались маленькие дети, то их необходимо заслонить собой.'),
      ];
    case 'Землятрясение':
      return [
        Recomendation(
            imagePath: 'assets/images/28.png',
            text: 'Ощутив колебания здания, не поддавайтесь панике.'),
        Recomendation(
            imagePath: 'assets/images/29.png',
            text:
                'Постарайтесь незамедлительно покинуть здание, быстро вывести из него всех людей или занять безопасное место'),
        Recomendation(
            imagePath: 'assets/images/30.png',
            text:
                'Покидать здание нужно после окончания первого толчка быстро и самым коротким путем'),
        Recomendation(
            imagePath: 'assets/images/31.png',
            text:
                'С собой следует взять только необходимые вещи, документы, деньги'),
        Recomendation(
            imagePath: 'assets/images/32.png',
            text: 'Не пользоваться лифтом во время землетрясения'),
        Recomendation(
            imagePath: 'assets/images/33.png',
            text:
                'При отсутствии возможности покинуть здание обычным путем можно использовать для этих целей веревки, связанные простыни.'),
        Recomendation(
            imagePath: 'assets/images/34.png',
            text:
                'Если вы вынужденно остались в помещении, то встаньте в безопасном месте. Самым безопасным местом в квартире, доме являются углы капитальных стен, проемы в этих стенах, пространство под несущими конструкциями. Если возможно, спрячьтесь под стол'),
      ];
    case 'Извержение вулкана':
      return [
        Recomendation(
            imagePath: 'assets/images/35.png',
            text: 'Защитите тело и голову от камней и пепла.'),
        Recomendation(
            imagePath: 'assets/images/36.png',
            text:
                'Извержение вулканов может сопровождаться бурным паводком, селевыми потоками, затоплениями, поэтому избегайте берегов рек и долин вблизи вулканов, старайтесь держаться возвышенных мест, чтобы не попасть в зону затопления или селевого потока'),
        Recomendation(
            imagePath: 'assets/images/37.png',
            text:
                'Закройте марлевой повязкой рот и нос, чтобы исключить вдыхание пепла'),
        Recomendation(
            imagePath: 'assets/images/38.png',
            text: 'Не пытайтесь ехать на автомобиле после выпадения пепла'),
        Recomendation(
            imagePath: 'assets/images/39.png',
            text:
                'Очистите от пепла крышу дома, чтобы исключить ее перегрузку и разрушение.'),
      ];
    case 'Камнепад / Оползень':
      return [
        Recomendation(
            imagePath: 'assets/images/35.png',
            text: 'Защитите тело и голову от камней и пепла.'),
        Recomendation(
            imagePath: 'assets/images/36.png',
            text:
                'Извержение вулканов может сопровождаться бурным паводком, селевыми потоками, затоплениями, поэтому избегайте берегов рек и долин вблизи вулканов, старайтесь держаться возвышенных мест, чтобы не попасть в зону затопления или селевого потока'),
        Recomendation(
            imagePath: 'assets/images/37.png',
            text:
                'Закройте марлевой повязкой рот и нос, чтобы исключить вдыхание пепла'),
        Recomendation(
            imagePath: 'assets/images/38.png',
            text: 'Не пытайтесь ехать на автомобиле после выпадения пепла'),
        Recomendation(
            imagePath: 'assets/images/39.png',
            text:
                'Очистите от пепла крышу дома, чтобы исключить ее перегрузку и разрушение.'),
      ];
    case 'Наводнение':
      return [
        Recomendation(
            imagePath: 'assets/images/40.png',
            text:
                'В установленном порядке выходите (выезжайте) из опасной зоны возможного катастрофического затопления в назначенный безопасный район или на возвышенные участки, местности, захватив с собой документы, ценности, необходимые вещи и двухсуточный запас непортящихся продуктов питания'),
        Recomendation(
            imagePath: 'assets/images/41.png',
            text: 'В конечном пункте эвакуации зарегистрируйтесь'),
        Recomendation(
            imagePath: 'assets/images/42.png',
            text:
                'Перед уходом из дома выключите электричество и газ, погасите огонь в отопительных печах, закрепите все плавучие предметы, находящиеся вне зданий, или разместите их в подсобных помещениях'),
        Recomendation(
            imagePath: 'assets/images/43.png',
            text:
                'Закройте окна и двери, при необходимости и наличии времени забейте снаружи досками (щитами) окна и двери первых этажей'),
        Recomendation(
            imagePath: 'assets/images/433.png',
            text:
                'При отсутствии организованной эвакуации, до прибытия помощи или спада воды, находитесь на верхних этажах и крышах зданий, на деревьях или других возвышающихся предметах'),
        Recomendation(
            imagePath: 'assets/images/44.png',
            text:
                'При этом постоянно подавайте сигнал бедствия: днем - вывешиванием или размахиванием хорошо видимым полотнищем, подбитым к древку, а в темное время - световым сигналом и периодически голосом'),
        Recomendation(
            imagePath: 'assets/images/45.png',
            text:
                'Самостоятельно выбираться из затопленного района рекомендуется только при наличии таких серьезных причин, как необходимость оказания медицинской помощи пострадавшим, продолжающийся подъем уровня воды, при угрозе затопления верхних этажей (чердака)'),
      ];
    case 'Пожар':
      return [
        Recomendation(
            imagePath: 'assets/images/44.png',
            text:
                'При обнаружении очага возгорания в лесу необходимо немедленно известить об этом противопожарную службу по номеру телефона 112'),
        Recomendation(
            imagePath: 'assets/images/37.png',
            text:
                'Двигаться нужно строго вдоль пожара. При нехватке кислорода рекомендуется дышать через мокрый платок или смоченную одежду.'),
        Recomendation(
            imagePath: 'assets/images/36.png',
            text:
                'Если нет возможности уйти от огня, нужно найти ближайший водоем или накрыться мокрой одеждой.'),
        Recomendation(
            imagePath: 'assets/images/41.png',
            text:
                'Забрать и держать при себе документы, поместить ценные вещи в безопасное доступное место'),
        Recomendation(
            imagePath: 'assets/images/50.png',
            text:
                'Надеть хлопчатобумажную или шерстяную одежду, при себе иметь перчатки, платок, средства защиты глаз (очки и др.)'),
        Recomendation(
            imagePath: 'assets/images/51.png',
            text: 'Подготовить запас еды и питьевой воды'),
        Recomendation(
            imagePath: 'assets/images/22.png',
            text:
                'Внимательно следить за сообщениями по телевидению и радио, средствами оповещения, держать связь со знакомыми в других районах вашей местности'),
        Recomendation(
            imagePath: 'assets/images/53.png', text: 'Избегать паники'),
      ];
    case "Радиактивный фон":
      return [
        Recomendation(
            imagePath: 'assets/images/37.png',
            text:
                'Находясь на улице, немедленно защитите органы дыхания платком (шарфом)'),
        Recomendation(
            imagePath: 'assets/images/54.png',
            text:
                'Придя домой, поместите верхнюю одежду и обувь в пластиковый пакет, примите душ'),
        Recomendation(
            imagePath: 'assets/images/43.png', text: 'Закройте окна и двери'),
        Recomendation(
            imagePath: 'assets/images/55.png',
            text:
                'Включите телевизор и радиоприемник для получения дополнительной информации об аварии'),
        Recomendation(
            imagePath: 'assets/images/29.png',
            text:
                'Выходите из помещения только в случае необходимости, используя при этом респиратор, плащ, резиновые сапоги и перчатки'),
        Recomendation(
            imagePath: 'assets/images/36.png',
            text:
                'На открытой местности не раздевайтесь, не садитесь на землю и не курите, исключите купание в открытых водоемах и сбор лесных ягод, грибов'),
        Recomendation(
            imagePath: 'assets/images/56.png',
            text:
                'Территорию возле дома периодически увлажняйте, а в помещении ежедневно проводите тщательную влажную уборку с применением моющих средств'),
        Recomendation(
            imagePath: 'assets/images/57.png',
            text:
                'Перед входом в помещение вымойте обувь, вытряхните и почистите влажной щеткой верхнюю одежду'),
        Recomendation(
            imagePath: 'assets/images/57.png',
            text:
                'Перед входом в помещение вымойте обувь, вытряхните и почистите влажной щеткой верхнюю одежду'),
        Recomendation(
            imagePath: 'assets/images/58.png',
            text: 'Воду употребляйте только из проверенных источников;'),
        Recomendation(
            imagePath: 'assets/images/59.png',
            text:
                'Тщательно мойте перед едой руки и полощите рот 0.5%-ным раствором питьевой соды'),
      ];
    case "Химическое заражение":
      return [
        Recomendation(
            imagePath: 'assets/images/37.png',
            text:
                'Находясь на улице, немедленно защитите органы дыхания платком (шарфом)'),
        Recomendation(
            imagePath: 'assets/images/54.png',
            text:
                'Придя домой, поместите верхнюю одежду и обувь в пластиковый пакет, примите душ'),
        Recomendation(
            imagePath: 'assets/images/43.png', text: 'Закройте окна и двери'),
        Recomendation(
            imagePath: 'assets/images/55.png',
            text:
                'Включите телевизор и радиоприемник для получения дополнительной информации об аварии'),
        Recomendation(
            imagePath: 'assets/images/29.png',
            text:
                'Выходите из помещения только в случае необходимости, используя при этом респиратор, плащ, резиновые сапоги и перчатки'),
        Recomendation(
            imagePath: 'assets/images/36.png',
            text:
                'На открытой местности не раздевайтесь, не садитесь на землю и не курите, исключите купание в открытых водоемах и сбор лесных ягод, грибов'),
        Recomendation(
            imagePath: 'assets/images/56.png',
            text:
                'Территорию возле дома периодически увлажняйте, а в помещении ежедневно проводите тщательную влажную уборку с применением моющих средств'),
        Recomendation(
            imagePath: 'assets/images/57.png',
            text:
                'Перед входом в помещение вымойте обувь, вытряхните и почистите влажной щеткой верхнюю одежду'),
        Recomendation(
            imagePath: 'assets/images/58.png',
            text: 'Воду употребляйте только из проверенных источников;'),
        Recomendation(
            imagePath: 'assets/images/59.png',
            text:
                'Тщательно мойте перед едой руки и полощите рот 0.5%-ным раствором питьевой соды'),
      ];
    case "Вирусное / бактериологическое заражение":
      return [
        Recomendation(
            imagePath: 'assets/images/37.png',
            text:
                'Находясь на улице, немедленно защитите органы дыхания платком (шарфом)'),
        Recomendation(
            imagePath: 'assets/images/54.png',
            text:
                'Придя домой, поместите верхнюю одежду и обувь в пластиковый пакет, примите душ'),
        Recomendation(
            imagePath: 'assets/images/43.png', text: 'Закройте окна и двери'),
        Recomendation(
            imagePath: 'assets/images/55.png',
            text:
                'Включите телевизор и радиоприемник для получения дополнительной информации об аварии'),
        Recomendation(
            imagePath: 'assets/images/29.png',
            text:
                'Выходите из помещения только в случае необходимости, используя при этом респиратор, плащ, резиновые сапоги и перчатки'),
        Recomendation(
            imagePath: 'assets/images/36.png',
            text:
                'На открытой местности не раздевайтесь, не садитесь на землю и не курите, исключите купание в открытых водоемах и сбор лесных ягод, грибов'),
        Recomendation(
            imagePath: 'assets/images/56.png',
            text:
                'Территорию возле дома периодически увлажняйте, а в помещении ежедневно проводите тщательную влажную уборку с применением моющих средств'),
        Recomendation(
            imagePath: 'assets/images/57.png',
            text:
                'Перед входом в помещение вымойте обувь, вытряхните и почистите влажной щеткой верхнюю одежду'),
        Recomendation(
            imagePath: 'assets/images/58.png',
            text: 'Воду употребляйте только из проверенных источников;'),
        Recomendation(
            imagePath: 'assets/images/59.png',
            text:
                'Тщательно мойте перед едой руки и полощите рот 0.5%-ным раствором питьевой соды'),
      ];
    case "Гололёд":
      return [
        Recomendation(
            imagePath: 'assets/images/37.png',
            text:
                'Подберите нескользящую обувь с подошвой на микропористой основе, отказавшись от высоких каблуков.'),
        Recomendation(
            imagePath: 'assets/images/54.png',
            text:
                'Смотрите себе под ноги, старайтесь обходить опасные места. Если ледяную "лужу" обойти невозможно, то передвигайтесь по ней, как лыжник, небольшими скользящими шажками.'),
        Recomendation(
            imagePath: 'assets/images/43.png',
            text:
                'Будьте предельно внимательны на проезжей части дороги: не торопитесь, не бегите.'),
        Recomendation(
            imagePath: 'assets/images/55.png',
            text:
                'Пожилым людям рекомендуется использовать трость с резиновым наконечником или специальную палку с шипами.'),
      ];
    case 'Солнечная радиация':
      return [
        Recomendation(
            imagePath: 'assets/images/59.png',
            text: 'Больше находиться в тени'),
        Recomendation(
            imagePath: 'assets/images/60.png',
            text:
                'Носить головные уборы и солнцезащитные очки, полностью закрывающие глаза'),
        Recomendation(
            imagePath: 'assets/images/61.png',
            text:
                'Пользоваться средствами с индексом фактора защиты (SPF) от ультрафиолета 30+'),
      ];
    case 'Сильный туман':
      return [
        Recomendation(
            imagePath: 'assets/images/62.png',
            text:
                'Необходимо ехать, увеличить, дистанцию, не совершать обгонов, резких маневров и торможения'),
        Recomendation(
            imagePath: 'assets/images/63.png',
            text:
                'Задние противотуманные фонари включать совместно с габаритными огнями'),
        Recomendation(
            imagePath: 'assets/images/64.png',
            text:
                'При запотевании стекол включить систему отопления и вентиляции салона, а также электрообогреватель заднего стекла'),
        Recomendation(
            imagePath: 'assets/images/65.png',
            text: 'При очень сильном тумане лучше остановиться и переждать'),
        Recomendation(
            imagePath: 'assets/images/66.png',
            text:
                'Окно двери водителя лучше держать открытым и прислушиваться к шуму других транспортных средств'),
        Recomendation(
            imagePath: 'assets/images/67.png',
            text:
                'Периодически использовать звуковой сигнал, особенно на загородной дороге'),
      ];
    case 'Цунами':
      return [
        Recomendation(
            imagePath: 'assets/images/68.png',
            text:
                'Жителям прибрежных населенных пунктов при получении сигнала тревоги цунами необходимо немедленно покинуть жилые и служебные помещения. Соблюдая порядок, уйти из опасной зоны согласно плану эвакуацииё'),
        Recomendation(
            imagePath: 'assets/images/69.png',
            text:
                'Необходимо уйти от побережья в глубину суши на возвышенность, где высота над уровнем моря составляет 30-40 метров. Если Вы находитесь на берегу замкнутой бухты, то эта высота должна быть не менее 5 метров; уходить от берега необходимо вверх по склонам, а не по долинам рек, так как наиболее далеко в глубь суши цунами проникает именно по рекам'),
        Recomendation(
            imagePath: 'assets/images/37.png',
            text:
                'При отсутствии поблизости возвышенности надо уйти от берега не менее чем на 2-3 километра'),
        Recomendation(
            imagePath: 'assets/images/37.png',
            text:
                'Не следует возвращаться на берег после первой волны ранее чем через 3 часа, так как за первой волной обычно следуют другие, причем вторая и третья волны часто достигают наибольшей силы'),
        Recomendation(
            imagePath: 'assets/images/37.png',
            text:
                'Судам, находящимся в прибрежных водах, стоящим на открытом рейде или в бухте с широким входом, а тем более у причалов, следует уйти в океан за 50-метровую изобату; курс следует держать перпендикулярно линии берега'),
        Recomendation(
            imagePath: 'assets/images/37.png',
            text:
                'Если в Вашем районе имеется система оповещения - ждите сигнала отбоя тревоги'),
      ];
  }
  return [];
}
