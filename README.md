 
# Домашнее задание 65 по курсу "Высокопроизводительные вычисления" Соколов Александр
 
для тестирования возьмем стандартное изображеие lena и нанесем на него в графическом редакторе помехи


Исходное изображение 

![lena_gray](https://user-images.githubusercontent.com/46603429/144723201-078f91ec-0425-42fe-9ffd-0ede18fff4f0.png)

с помехами

![lena_gray_noise](https://user-images.githubusercontent.com/46603429/144723206-f956c698-da9a-47a7-b180-ca4be8a86a58.png)


# Задача №1a. фильтр
- путь к программе src/matrix_filter.cu
- компиляция nvcc -arch sm_61 matrix_filter.cu -o 1
- запуск ./1
Исходное изображение 

![lena_gray_noise](https://user-images.githubusercontent.com/46603429/144723206-f956c698-da9a-47a7-b180-ca4be8a86a58.png)


Результат применения фильтра "размытие 5х5" значения всех элементов фильтра равны 1

![lena_matrix_filter](https://user-images.githubusercontent.com/46603429/144723370-14f96d84-37dd-4ea7-9cbd-5b1093220bf2.png)



# Задача №1б. медианный фильтр 
- путь к программе src/median.cu
- компиляция nvcc -arch sm_61 median.cu -o 2
- запуск ./2
Исходное изображение 

![lena_gray_noise](https://user-images.githubusercontent.com/46603429/144723206-f956c698-da9a-47a7-b180-ca4be8a86a58.png)

результат применения медианного фильтра

![lena_gray_median](https://user-images.githubusercontent.com/46603429/144723495-d8510447-a493-4fce-a834-c2761005b3b5.png)


# Задача №2. расчет гистограммы яркости .
гистограмма выводится в нормализованном виде.

- путь к программе src/median.cu
- компиляция nvcc -arch sm_61 histogram.cu -o 3
- запуск ./3
вывод
``` color 	 normalized value
color 0 	 0.000000
color 1 	 0.000000
color 2 	 0.000000
color 3 	 0.000000
color 4 	 0.000000
color 5 	 0.000000
color 6 	 0.000000
color 7 	 0.000000
color 8 	 0.000000
color 9 	 0.000000
color 10 	 0.000000
color 11 	 0.000000
color 12 	 0.000000
color 13 	 0.000000
color 14 	 0.000000
color 15 	 0.000000
color 16 	 0.000000
color 17 	 0.000000
color 18 	 0.000000
color 19 	 0.000000
color 20 	 0.000000
color 21 	 0.000000
color 22 	 0.000000
color 23 	 0.000000
color 24 	 0.000000
color 25 	 0.000000
color 26 	 0.000000
color 27 	 0.000012
color 28 	 0.000058
color 29 	 0.000311
color 30 	 0.001246
color 31 	 0.004948
color 32 	 0.011568
color 33 	 0.020092
color 34 	 0.025097
color 35 	 0.027808
color 36 	 0.025582
color 37 	 0.019838
color 38 	 0.015213
color 39 	 0.013137
color 40 	 0.010703
color 41 	 0.008673
color 42 	 0.007993
color 43 	 0.007508
color 44 	 0.007566
color 45 	 0.007382
color 46 	 0.007278
color 47 	 0.007243
color 48 	 0.006320
color 49 	 0.006286
color 50 	 0.006493
color 51 	 0.005790
color 52 	 0.005836
color 53 	 0.006044
color 54 	 0.004844
color 55 	 0.005686
color 56 	 0.005248
color 57 	 0.005675
color 58 	 0.005686
color 59 	 0.005905
color 60 	 0.006378
color 61 	 0.006793
color 62 	 0.007635
color 63 	 0.008200
color 64 	 0.008466
color 65 	 0.008339
color 66 	 0.007047
color 67 	 0.007301
color 68 	 0.006505
color 69 	 0.005824
color 70 	 0.006067
color 71 	 0.006032
color 72 	 0.005951
color 73 	 0.006263
color 74 	 0.006274
color 75 	 0.006101
color 76 	 0.006101
color 77 	 0.005951
color 78 	 0.006263
color 79 	 0.006044
color 80 	 0.005974
color 81 	 0.005894
color 82 	 0.006782
color 83 	 0.006620
color 84 	 0.006609
color 85 	 0.007047
color 86 	 0.006782
color 87 	 0.006470
color 88 	 0.006620
color 89 	 0.006493
color 90 	 0.006401
color 91 	 0.007197
color 92 	 0.007047
color 93 	 0.007220
color 94 	 0.007012
color 95 	 0.006655
color 96 	 0.006401
color 97 	 0.007347
color 98 	 0.007220
color 99 	 0.007912
color 100 	 0.008027
color 101 	 0.009215
color 102 	 0.010484
color 103 	 0.011499
color 104 	 0.011660
color 105 	 0.012502
color 106 	 0.012237
color 107 	 0.011937
color 108 	 0.010438
color 109 	 0.011084
color 110 	 0.010715
color 111 	 0.010519
color 112 	 0.009804
color 113 	 0.009204
color 114 	 0.008869
color 115 	 0.008039
color 116 	 0.008108
color 117 	 0.007278
color 118 	 0.006747
color 119 	 0.006251
color 120 	 0.006482
color 121 	 0.005778
color 122 	 0.005490
color 123 	 0.004936
color 124 	 0.004844
color 125 	 0.004590
color 126 	 0.004971
color 127 	 0.005709
color 128 	 0.005859
color 129 	 0.006078
color 130 	 0.005651
color 131 	 0.005675
color 132 	 0.005928
color 133 	 0.005340
color 134 	 0.005213
color 135 	 0.004706
color 136 	 0.004452
color 137 	 0.003771
color 138 	 0.003518
color 139 	 0.002999
color 140 	 0.002964
color 141 	 0.002768
color 142 	 0.002549
color 143 	 0.002503
color 144 	 0.002364
color 145 	 0.002468
color 146 	 0.002249
color 147 	 0.002387
color 148 	 0.002226
color 149 	 0.002168
color 150 	 0.002318
color 151 	 0.002411
color 152 	 0.002238
color 153 	 0.002214
color 154 	 0.002745
color 155 	 0.002664
color 156 	 0.002549
color 157 	 0.002918
color 158 	 0.002607
color 159 	 0.003045
color 160 	 0.002976
color 161 	 0.002560
color 162 	 0.002872
color 163 	 0.002837
color 164 	 0.002607
color 165 	 0.002733
color 166 	 0.002710
color 167 	 0.002560
color 168 	 0.002641
color 169 	 0.002630
color 170 	 0.002837
color 171 	 0.002641
color 172 	 0.002757
color 173 	 0.002376
color 174 	 0.002687
color 175 	 0.002180
color 176 	 0.002491
color 177 	 0.002076
color 178 	 0.002214
color 179 	 0.002699
color 180 	 0.002318
color 181 	 0.002653
color 182 	 0.002376
color 183 	 0.002307
color 184 	 0.002618
color 185 	 0.002514
color 186 	 0.002318
color 187 	 0.002307
color 188 	 0.001949
color 189 	 0.001742
color 190 	 0.001557
color 191 	 0.001234
color 192 	 0.000992
color 193 	 0.000842
color 194 	 0.000807
color 195 	 0.000577
color 196 	 0.000484
color 197 	 0.000369
color 198 	 0.000415
color 199 	 0.000427
color 200 	 0.000346
color 201 	 0.000415
color 202 	 0.000208
color 203 	 0.000277
color 204 	 0.000150
color 205 	 0.000185
color 206 	 0.000081
color 207 	 0.000058
color 208 	 0.000035
color 209 	 0.000023
color 210 	 0.000000
color 211 	 0.000023
color 212 	 0.000000
color 213 	 0.000000
color 214 	 0.000012
color 215 	 0.000012
color 216 	 0.000000
color 217 	 0.000012
color 218 	 0.000000
color 219 	 0.000000
color 220 	 0.000000
color 221 	 0.000000
color 222 	 0.000000
color 223 	 0.000000
color 224 	 0.000000
color 225 	 0.000000
color 226 	 0.000000
color 227 	 0.000000
color 228 	 0.000000
color 229 	 0.000000
color 230 	 0.000000
color 231 	 0.000000
color 232 	 0.000000
color 233 	 0.000000
color 234 	 0.000000
color 235 	 0.000000
color 236 	 0.000000
color 237 	 0.000000
color 238 	 0.000000
color 239 	 0.000000
color 240 	 0.000000
color 241 	 0.000000
color 242 	 0.000000
color 243 	 0.000000
color 244 	 0.000000
color 245 	 0.000000
color 246 	 0.000000
color 247 	 0.000000
color 248 	 0.000000
color 249 	 0.000000
color 250 	 0.000000
color 251 	 0.000000
color 252 	 0.000000
color 253 	 0.000000
color 254 	 0.000000
```

