---
layout: post
title: Play Around Java Date Formating with Localization
description: some tips for localizing date time
tags: 
    - {tags}
---

# Play Around Java DateFormat with Localization

Localization is a fun thing because different counties have different display rules like text has left-to-right and right-to-left directions. Date has different formats too. The year, month, day are ordered differently in different countries. For example, the format is `Month/Day/Year` in U.S. and the format is `Day/Month/Year` in U.K. 
If you don't know those things. The applications might looks weird in foreign languages. And there I will share some tips for how to display date correctly. 

> There is [a wiki page](https://en.wikipedia.org/wiki/Date_format_by_country) that show all the format list in different countries.

## Use DateFormat Class

Java has a class called java.text.DateFormat, this class has 4 styles for formating

- short: show day in week, number of month, year
- medium: show day in week, abbreviated text of month, year
- long: show day in week, text of month, year
- full: show day in week, day in month, text of month, year
- default : as medium


This is an easiest example to use DateFormat, it will use the current locale and medium style to format the date.
```java
String dateString = DateFormat.getDateInstance().format(date)
```

You can give two parameters, style and locale, as the below example.
```java
String dateString = DateFormat.getDateInstance(DateFormat.SHORT, Locale.CHINA).format(new Date())
```

> see https://docs.oracle.com/javase/8/docs/api/java/text/DateFormat.html and https://docs.oracle.com/javase/tutorial/i18n/format/dateFormat.html for more information.

## Parse the Pattern

Unfortunately, Java doesn't support only month day formating and if we focus use `M/d` format that will cause the date formating improper in some countries. But the good thing is we can get the pattern by calling SimpleDateFormat.toPattern() to get the date pattern on the given or default style and locale.

``` java
SimpleDateFormat df = (SimpleDateFormat)DateFormat.getDateInstance(DateFormat.SHORT);

// the pattern in en_US is M/d/yy
String pattern = df.toPattern();

// use the separators to break pattern to array,
// so we can know the order by the pattern
// the orders in en_US is [M, d, yy]
String[] orders = pattern.split("[-. /,]")
```

Whit the same idea, we can just remove year in the pattern, so we can display only month day in correct format.

``` java
SimpleDateFormat df = (SimpleDateFormat)DateFormat.getDateInstance();
String pattern = df.toPattern();

// remove year in pattern
String patternNoYear = pattern.replaceAll("[-. /,]*[yYG]+[-. /,]*", "");
String mmddString = new SimpleDateFormat(patternNoYear, Locale.getDefault()).format(today);
```

To validate this idea is correct, we can run this test to see the results in all locales are correct.

``` java
import java.util.Date;
import java.util.Locale;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

class Test {
    public static void main(String[ ] args) {
        Date today = new Date();
        for (Locale locale : Locale.getAvailableLocales()) {
            SimpleDateFormat df = (SimpleDateFormat)DateFormat.getDateInstance(DateFormat.DEFAULT, locale);
            String pattern = df.toPattern();
            String patternNoYear = pattern.replaceAll("[-. /,]*[yYG]+[-. /,]*", "");

            SimpleDateFormat df2 = new SimpleDateFormat(patternNoYear, locale);
            String result = df2.format(today);

            System.out.println(String.format("locale=%s, pattern=%s, patternNoYear=%s, result=%s", locale, pattern, patternNoYear, result));
        }
    }
}

/* some outputs of above code
locale=ar_AE, pattern=dd/MM/yyyy, patternNoYear=dd/MM, result=24/10
locale=ar_JO, pattern=dd/MM/yyyy, patternNoYear=dd/MM, result=24/10
locale=ar_SY, pattern=dd/MM/yyyy, patternNoYear=dd/MM, result=24/10
locale=hr_HR, pattern=dd.MM.yyyy., patternNoYear=dd.MM, result=24.10
locale=fr_BE, pattern=dd-MMM-yyyy, patternNoYear=dd-MMM, result=24-oct.
locale=es_PA, pattern=MM/dd/yyyy, patternNoYear=MM/dd, result=10/24
locale=mt_MT, pattern=dd MMM yyyy, patternNoYear=dd MMM, result=24 Ott
locale=es_VE, pattern=dd/MM/yyyy, patternNoYear=dd/MM, result=24/10
locale=bg, pattern=dd.MM.yyyy, patternNoYear=dd.MM, result=24.10
locale=zh_TW, pattern=yyyy/M/d, patternNoYear=M/d, result=10/24
locale=it, pattern=d-MMM-yyyy, patternNoYear=d-MMM, result=24-ott
locale=ko, pattern=yyyy. M. d, patternNoYear=M. d, result=10. 24
*/
```


## An example in Android
The below is an example that I initial the mmddFormat. so every times the app has to show only month and day, it just calls mmddFormat to do the formating.

``` java
import android.app.Activity;
import android.content.res.Configuration;
import android.os.Bundle;

import java.text.SimpleDateFormat;
import java.util.Locale;

public class MainActivity extends Activity {

    Locale currentLocale;
    SimpleDateFormat mmddFormat;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        currentLocale = Locale.getDefault();
        updateLocaleSettings();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        // update the format if the user update the language of the device
        // need add <activity android:configChanges="locale"> in AndroidManifest.xml 
        if (!newConfig.locale.equals(currentLocale)) {
            currentLocale = newConfig.locale;
            updateLocaleSettings();
        }
    }

    private void updateLocaleSettings() {
        String mmDDPattern = ((SimpleDateFormat)SimpleDateFormat.getDateInstance(SimpleDateFormat.SHORT)).toPattern().replace("[-. /,]*[yYG]+[-. /,]*", "");
        mmddFormat = new SimpleDateFormat(mmDDPattern, currentLocale);
    }
}
```
