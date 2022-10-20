#### Project Data Analysis for B2B Retail: Customer Analytics Report
Source : https://academy.dqlab.id/main/package/project/246?pf=0

----

#### Memahami table
Sebelum memulai menyusun query SQL dan membuat Analisa dari hasil query, hal pertama yang perlu dilakukan adalah menjadi familiar dengan tabel yang akan digunakan. Hal ini akan sangat berguna dalam menentukan kolom mana sekiranya berkaitan dengan problem yang akan dianalisa, dan proses manipulasi data apa yang sekiranya perlu dilakukan untuk kolom – kolom tersebut, karena tidak semua kolom pada tabel perlu untuk digunakan.</br>
</br>
Mengecek tabel orders_1 :SELECT * FROM orders_1 limit 5;</br>
Mengecek tabel orders_2 :SELECT * FROM orders_2 limit 5;</br>
Mengecek tabel customer :SELECT * FROM customer limit 5;

```sql
SELECT * FROM orders_1 LIMIT 5;
SELECT * FROM orders_2 LIMIT 5;
SELECT * FROM customer LIMIT 5;
```

<details>
<summary markdown="span">orders_1</summary>

| orderNumber | orderDate  | requiredDate | shippedDate | status  | customerID | productCode | quantity | priceeach |
|-------------|------------|--------------|-------------|---------|------------|-------------|----------|-----------|
|       10234 | 2004-03-30 | 2004-04-05   | 2004-04-02  | Shipped |        412 | S72_1253    |       40 |     45690 |
|       10234 | 2004-03-30 | 2004-04-05   | 2004-04-02  | Shipped |        412 | S700_2047   |       29 |     83280 |
|       10234 | 2004-03-30 | 2004-04-05   | 2004-04-02  | Shipped |        412 | S24_3816    |       31 |     78830 |
|       10234 | 2004-03-30 | 2004-04-05   | 2004-04-02  | Shipped |        412 | S24_3420    |       25 |     65090 |
|       10234 | 2004-03-30 | 2004-04-05   | 2004-04-02  | Shipped |        412 | S24_2841    |       44 |     67140 |

</details>

<details>
<summary markdown="span">orders_2</summary>

| orderNumber | orderDate  | requiredDate | shippedDate | status  | customerID | productCode | quantity | priceeach |
|-------------|------------|--------------|-------------|---------|------------|-------------|----------|-----------|
|       10235 | 2004-04-02 | 2004-04-12   | 2004-04-06  | Shipped |        260 | S18_2581    |       24 |     81950 |
|       10235 | 2004-04-02 | 2004-04-12   | 2004-04-06  | Shipped |        260 | S24_1785    |       23 |     89720 |
|       10235 | 2004-04-02 | 2004-04-12   | 2004-04-06  | Shipped |        260 | S24_3949    |       33 |     55270 |
|       10235 | 2004-04-02 | 2004-04-12   | 2004-04-06  | Shipped |        260 | S24_4278    |       40 |     63030 |
|       10235 | 2004-04-02 | 2004-04-12   | 2004-04-06  | Shipped |        260 | S32_1374    |       41 |     90900 |

</details>

<details>
<summary markdown="span">customer</summary>

| customerID | customerName               | contactLastName | contactFirstName | city      | country   | createDate |
|------------|----------------------------|-----------------|------------------|-----------|-----------|------------|
|        103 | Atelier graphique          | Schmitt         | Carine           | Nantes    | France    | 2004-02-05 |
|        112 | Signal Gift Stores         | King            | Jean             | Las Vegas | USA       | 2004-02-05 |
|        114 | Australian Collectors, Co. | Ferguson        | Peter            | Melbourne | Australia | 2004-02-20 |
|        119 | La Rochelle Gifts          | Labrune         | Janine           | Nantes    | France    | 2004-02-05 |
|        121 | Baane Mini Imports         | Bergulfsen      | Jonas            | Stavern   | Norway    | 2004-02-05 |

</details>

----

#### Total Penjualan dan Revenue pada Quarter-1 (Jan, Feb, Mar) dan Quarter-2 (Apr,Mei,Jun)
Dari tabel orders_1 lakukan penjumlahan pada kolom quantity dengan fungsi aggregate sum() dan beri nama “total_penjualan”, kalikan kolom quantity dengan kolom priceEach kemudian jumlahkan hasil perkalian kedua kolom tersebut dan beri nama “revenue”</br>
</br>
Perusahaan hanya ingin menghitung penjualan dari produk yang terkirim saja, jadi kita perlu mem-filter kolom ‘status’ sehingga hanya menampilkan order dengan status “Shipped”.</br>
</br>
Lakukan Langkah 1 & 2, untuk tabel orders_2.</br>

```sql
select 
  SUM(quantity) AS total_penjualan, 
  SUM(quantity*priceeach) AS revenue
FROM 
  orders_1
WHERE 
  status="shipped";
```

<details>
<summary markdown="span">OUTPUT :</summary>
  
| total_penjualan | revenue   |
|-----------------|-----------|
|            8694 | 799579310 |

</details>

```sql
select 
  SUM(quantity) AS total_penjualan, 
  SUM(quantity*priceeach) AS revenue
FROM 
  orders_2
WHERE 
  status="shipped";
```
  
<details>
<summary markdown="span">OUTPUT :</summary>

| total_penjualan | revenue   |
|-----------------|-----------|
|            6717 | 607548320 |

</details>

----

#### Menghitung persentasi keseluruhan penjualan
Kedua tabel orders_1 dan orders_2 masih terpisah, untuk menghitung persentasi keseluruhan penjualan dari kedua tabel tersebut perlu digabungkan :</br>
1. Pilihlah kolom “orderNumber”, “status”, “quantity”, “priceEach” pada tabel orders_1, dan tambahkan kolom baru dengan nama “quarter” dan isi dengan value “1”. Lakukan yang sama dengan tabel orders_2, dan isi dengan value “2”, kemudian gabungkan kedua tabel tersebut.</br>
2. Gunakan statement dari Langkah 1 sebagai subquery dan beri alias “tabel_a”.</br>
3. Dari “tabel_a”, lakukan penjumlahan pada kolom “quantity” dengan fungsi aggregate sum() dan beri nama “total_penjualan”, dan kalikan kolom quantity dengan kolom priceEach kemudian jumlahkan hasil perkalian kedua kolom tersebut dan beri nama “revenue”</br>
4. Filter kolom ‘status’ sehingga hanya menampilkan order dengan status “Shipped”.</br>
5. Kelompokkan total_penjualan berdasarkan kolom “quarter”, dan jangan lupa menambahkan kolom ini pada bagian select.

```sql
SELETC 
  quarter, 
  SUM(quantity) AS total_penjualan,
  SUM(quantity*priceeach) AS revenue
FROM
  (SELECT ordernumber, status, quantity, priceeach, 1 AS quarter from orders_1
UNION
  SELECT ordernumber, status, quantity, priceeach, 2 AS quarter from orders_2) AS table_a
WHERE 
  status="shipped"
GROUP BY 
  quarter;
```
<details>
<summary markdown="span">OUTPUT :</summary>
  
| quarter | total_penjualan | revenue   |
|---------|-----------------|-----------|
|       1 |            8694 | 799579310 |
|       2 |            6717 | 607548320 |
  
</details>

----

#### Perhitungan Growth Penjualan dan Revenue
Untuk project ini, perhitungan pertumbuhan penjualan akan dilakukan secara manual menggunakan formula yang disediakan di bawah.
</br>
%Growth Penjualan = (6717 – 8694)/8694 = -22%</br>
%Growth Revenue = (607548320 – 799579310)/ 799579310 = -24%

----

#### Apakah jumlah customers xyz.com semakin bertambah?
Penambahan jumlah customers dapat diukur dengan membandingkan total jumlah customers yang registrasi di periode saat ini dengan total jumlah customers yang registrasi diakhir periode sebelumnya.</br>
1. Dari tabel customer, pilihlah kolom customerID, createDate dan tambahkan kolom baru dengan menggunakan fungsi QUARTER(…) untuk mengekstrak nilai quarter dari CreateDate dan beri nama “quarter”</br>
2. Filter kolom “createDate” sehingga hanya menampilkan baris dengan createDate antara 1 Januari 2004 dan 30Juni 2004.</br>
3. Gunakan statement Langkah 1 & 2 sebagai subquery dengan alias tabel_b.</br>
4. Hitunglah jumlah unik customers à tidak ada duplikasi customers dan beri nama “total_customers”</br>
5. Kelompokkan total_customer berdasarkan kolom “quarter”, dan jangan lupa menambahkan kolom ini pada bagian select.

```sql
SELECT 
  quarter, 
  count(distinct customerid) AS total_customers
FROM
  (SELECT customerid, createdate, quarter(createdate) AS quarter 
  FROM customer WHERE QUARTER(createdate) <= 2) AS table_b
GROUP BY quarter;
```

<details>
<summary markdown="span">OUTPUT :</summary>

| quarter | total_customers |
|---------|-----------------|
|       1 |              43 |
|       2 |              35 |

</details>

----

#### Seberapa banyak customers tersebut yang sudah melakukan transaksi?
Problem ini merupakan kelanjutan dari problem sebelumnya yaitu dari sejumlah customer yang registrasi di periode quarter-1 dan quarter-2, berapa banyak yang sudah melakukan transaksi</br>
1. Dari tabel customer, pilihlah kolom customerID, createDate dan tambahkan kolom baru dengan menggunakan fungsi QUARTER(…) untuk mengekstrak nilai quarter dari CreateDate dan beri nama “quarter”</br>
2. Filter kolom “createDate” sehingga hanya menampilkan baris dengan createDate antara 1 Januari 2004 dan 30 Juni 2004.</br>
3. Gunakan statement Langkah A&B sebagai subquery dengan alias tabel_b.</br>
4. Dari tabel orders_1 dan orders_2, pilihlah kolom customerID, gunakan DISTINCT untuk menghilangkan duplikasi, kemudian gabungkan dengan kedua tabel tersebut dengan UNION.</br>
5. Filter tabel_b dengan operator IN() menggunakan 'Select statement langkah 4' , sehingga hanya customerID yang pernah bertransaksi (customerID tercatat di tabel orders) yang diperhitungkan.</br>
6. Hitunglah jumlah unik customers (tidak ada duplikasi customers) di statement SELECT dan beri nama “total_customers”.</br>
7. Kelompokkan total_customer berdasarkan kolom “quarter”, dan jangan lupa menambahkan kolom ini pada bagian select.

```sql
SELECT 
  quarter, 
  count(distinct customerid) AS total_customers 
FROM 
  (SELECT 
    customerid, 
    createdate, 
    quarter(createdate) AS quarter 
  FROM 
    customer
  WHERE 
    createdate between "2004-01-01" and "2004-06-30") AS table_b
WHERE 
  customerid 
  IN
    (SELECT DISTINCT customerid
    FROM
      orders_1
    UNION
    SELECT DISTINCT customerid
    FROM
      orders_2)
GROUP BY 
  quarter;
```

<details>
<summary markdown="span">OUTPUT :</summary>
  
| quarter | total_customers |
|---------|-----------------|
|       1 |              25 |
|       2 |              19 |
  
</details>

----

#### Category produk apa saja yang paling banyak di-order oleh customers di Quarter-2?
Untuk mengetahui kategori produk yang paling banyak dibeli, maka dapat dilakukan dengan menghitung total order dan jumlah penjualan dari setiap kategori produk.</br>
1. Dari kolom orders_2, pilih productCode, orderNumber, quantity, status.</br>
2. Tambahkan kolom baru dengan mengekstrak 3 karakter awal dari productCode yang merupakan ID untuk kategori produk; dan beri nama categoryID.</br>
3. Filter kolom “status” sehingga hanya produk dengan status “Shipped” yang diperhitungkan.</br>
4. Gunakan statement Langkah 1, 2, dan 3 sebagai subquery dengan alias tabel_c.</br>
5. Hitunglah total order dari kolom “orderNumber” dan beri nama “total_order”, dan jumlah penjualan dari kolom “quantity” dan beri nama “total_penjualan”.</br>
6. Kelompokkan berdasarkan categoryID, dan jangan lupa menambahkan kolom ini pada bagian select.</br>
7. Urutkan berdasarkan “total_order” dari terbesar ke terkecil.</br>

```sql
SELECT 
  * 
FROM
  (SELECT 
    categoryid, 
    count(distinct ordernumber) AS total_order, 
    sum(quantity) AS total_penjualan
  FROM
    (SELECT productcode, 
      ordernumber, 
      quantity, 
      status,
      LEFT(productcode,3) AS categoryid 
    FROM 
      orders_2
    WHERE status="shipped") AS table_c
  GROUP BY categoryid) a
ORDER BY 
  total_order
DESC;
```

<details>
<summary markdown="span">OUTPUT :</summary>

| categoryid | total_order | total_penjualan |
|------------|-------------|-----------------|
| S18        |          25 |            2264 |
| S24        |          21 |            1826 |
| S32        |          11 |             616 |
| S12        |          10 |             491 |
| S50        |           8 |             292 |
| S10        |           8 |             492 |
| S70        |           7 |             675 |
| S72        |           2 |              61 |

</details>

----

#### Seberapa banyak customers yang tetap aktif bertransaksi setelah transaksi pertamanya?
Mengetahui seberapa banyak customers yang tetap aktif menunjukkan apakah xyz.com tetap digemari oleh customers untuk memesan kebutuhan bisnis mereka. Hal ini juga dapat menjadi dasar bagi tim product dan business untuk pengembangan product dan business kedepannya. Adapun metrik yang digunakan disebut retention cohort. Untuk project ini, kita akan menghitung retention dengan query SQL sederhana, sedangkan cara lain yaitu JOIN dan SELF JOIN akan dibahas dimateri selanjutnya :</br>
</br>
Oleh karena baru terdapat 2 periode yang Quarter 1 dan Quarter 2, maka retention yang dapat dihitung adalah retention dari customers yang berbelanja di Quarter 1 dan kembali berbelanja di Quarter 2, sedangkan untuk customers yang berbelanja di Quarter 2 baru bisa dihitung retentionnya di Quarter 3.</br>
1. Dari tabel orders_1, tambahkan kolom baru dengan value “1” dan beri nama “quarter”.</br>
2. Dari tabel orders_2, pilihlah kolom customerID, gunakan distinct untuk menghilangkan duplikasi.</br>
3. Filter tabel orders_1 dengan operator IN() menggunakan 'Select statement langkah 2', sehingga hanya customerID yang pernah bertransaksi di quarter 2 (customerID tercatat di tabel orders_2) yang diperhitungkan.</br>
4. Hitunglah jumlah unik customers (tidak ada duplikasi customers) dibagi dengan total_ customers dalam percentage, pada Select statement dan beri nama “Q2”.</br>

```sql
#Menghitung total unik customers yang transaksi di quarter_1
SELECT 
  COUNT(DISTINCT customerID) AS total_customers 
FROM 
  orders_1;
#output = 25
```

<details>
<summary markdown="span">OUTPUT :</summary>
  
| total_customers |
|-----------------|
|              25 |
  
</details>

```sql
SELECT
  1 as quarter, 
  (COUNT(DISTINCT customerid)/25*100) AS Q2 
FROM 
  orders_1 
WHERE 
  customerid 
  IN(SELECT DISTINCT customerid FROM orders_2);
```

<details>
<summary markdown="span">OUTPUT :</summary>
  
| quarter | Q2      |
|---------+---------|
|       1 | 24.0000 |
  
</details>

----

####









