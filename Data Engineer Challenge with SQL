# Tampilkan daftar produk yang memiliki harga antara 50.000 dan 150.000
SELECT * FROM ms_produk
WHERE harga BETWEEN 50000 AND 150000;

# Tampilkan semua produk Flashdisk
SELECT * FROM ms_produk
WHERE nama_produk IN ('Flashdisk DQLab 64 gb','Flashdisk DQLab 32 GB');

# Tampilkan nama pelanggan yang memiliki gelar : S.H,Ir. dan Drs
SELECT 
  no_urut,kode_pelanggan,
  nama_pelanggan, 
  alamat 
FROM ms_pelanggan
WHERE 
  nama_pelanggan LIKE "Ir.%" OR 
  nama_pelanggan LIKE "%S.H." OR
  nama_pelanggan LIKE "%Drs.";

# Mengurutkan nama pelanggan
SELECT nama_pelanggan FROM ms_pelanggan 
ORDER BY 1 ASC;

# Mengurutkan nama pelanggan tanpa gelar 
SELECT nama_pelanggan FROM ms_pelanggan
ORDER BY 
  CASE WHEN LEFT(nama_pelanggan,3) = 'Ir.'
THEN SUBSTRING (nama_pelanggan,5,100)
ELSE nama_pelanggan END ASC;

# Tampilkan nama pelanggan yang memiliki nama paling panjangn
SELECT * FROM (
  SELECT nama_pelanggan 
  FROM ms_pelanggan
  ORDER BY LENGTH(nama_pelanggan) DESC, 1) a
LIMIT 1;

# Tampilkan nama orang yang memiliki nama paling panjang (pada row atas), dan nama orang paling pendek setelanya
SELECT * FROM (
  SELECT nama_pelanggan
  FROM ms_pelanggan
  ORDER BY LENGTH(nama_pelanggan) DESC,1
  LIMIT 1)a
UNION ALL
SELECT * FROM(
  SELECT nama_pelanggan
  FROM ms_pelanggan
  ORDER BY LENGTH(nama_pelanggan) asc, 1
  LIMIT 1)b

# Tampilkan produk yang paling banyak terjual dari segi kuantitas 
SELECT 
  kode_produk, 
  nama_produk,
  total_qty
FROM(
  SELECT 
    a.kode_produk,
    a.nama_produk,
    SUM(b.qty) as total_qty
  FROM ms_produk a 
  JOIN tr_penjualan_detail b ON a.kode_produk = b.kode_produk 
  GROUP BY 1,2 
  ORDER BY 3 DESC) a LIMIT 2;

# Pelanggan paling tinggi nilai belanjanya
SELECT * FROM(
  SELECT
    a.kode_pelanggan,
    a.nama_pelanggan,
    SUM(c.harga_satuan * qty) total_harga
  FROM ms_pelanggan a
  JOIN tr_penjualan b ON a.kode_pelanggan = b.kode_pelanggan
  JOIN tr_penjualan_detail c ON b.kode_transaksi = c.kode_transaksi
  GROUP BY 1,2
  ORDER BY 3 DESC)a
LIMIT 1;
    
# Tampilkan daftar pelanggan yang belum pernah melakukan transaksi
SELECT 
  a.kode_pelanggan,
  a.nama_pelanggan,
  a.alamat
FROM ms_pelanggan a
WHERE a.kode_pelanggan NOT IN (
  SELECT b.kode_pelanggan
  FROM tr_penjualan b);

# Tampilkan transaksi-transaksi yang memiliki jumlah item produk lebih dari 1 jenis produk
SELECT 
  a.kode_transaksi,
  a.kode_pelanggan,
  b.nama_pelanggan,
  a.tanggal_transaksi,
  COUNT(c.kode_transaksi) jumlah_detail
FROM tr_penjualan a 
JOIN ms_pelanggan b ON a.kode_pelanggan = b.kode_pelanggan
JOIN tr_penjualan_detail c ON a.kode_transaksi = c.kode_transaksi
GROUP BY 1,2,3,4
HAVING COUNT(c.kode_transaksi) > 1;

