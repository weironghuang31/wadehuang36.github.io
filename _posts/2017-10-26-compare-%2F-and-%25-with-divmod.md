---
layout: post
title: Compare / and % with divmod
description: do you wonder using / and % or divmod to get quotient and remainder which one is more effective.
tags: 
    - division
    - algorithm
---

# Compare / and % with divmod

Generally, when we want to get a quotient and a remainder from a number divided by another number. We will use two arithmetic operators `/ and %` to get them. However, you might not know some programming languages provider some functions like `divmod` in python that return the quotient and the remainder together. Let see both methods in the python code.

``` python

# method 1
quotient = 99 // 5 # // is Floor division which
remainder = 99 % 5

# method 2
quotient, remainder = divmod(99, 5)
```

Looks like method 2 is more elegant. At least, I like method 2 better. However, division and modulus are instructions that build in CPU and method 2 is a function provided by programming languages. Therefore, using method 1 should have better running performance, but we don't know if we really evaluate them.

## Compare to divmod in python
``` python
def method1(a, b):
    quotient = a // b
    remainder = a % b

    return (quotient, remainder)

def method2(a, b):
    return divmod(a, b)
```

## Compare to System.Math.DivRem in C# 7.0
``` cs
public static (int quotient, int remainder) Method1(int a, int b)
{
    int remainder = a % b;
    int quotient = a / b;

    return (quotient, remainder);
}

public static (int quotient, int remainder) Method2(int a, int b)
{
    int remainder;
    int quotient = Math.DivRem(a, b, out remainder);

    return (quotient, remainder);
}
```

This table are the results of calling each methods 100,000 times.

|Language|Method 1|Method 2|
|---|---|---|
|Python|20ms|25ms|
|C#|3.3ms|3.8ms|


Looks the two methods don't has much differences. I can use the method 2 on some things performance are not real core feature.

By the way, I just wonder the implement of divmod is might be a combination of two operators like is
``` python
def divmod(a, b):
    return (a // b, a % b)
```

> see how to implement [Division Algorithm](https://en.m.wikipedia.org/wiki/Division_algorithm) in the wiki.

