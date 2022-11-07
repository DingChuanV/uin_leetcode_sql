-- 请统计每个城市中评分最高的司机平均评分、日均接单和日均行驶里程数
-- 注：
-- 由多个司机评分并列最高的时候，都输出
-- 平均评分和日均评分接单量保留1位小数
-- 日均行驶里程数保留3位小数，按日均接单数升序排序

-- 业务背景
-- # 1. 用户提交打车请求后，在用户记录表生成一条打车记录，order_id订单号设为null
-- # 2. 当有司机接单时，在打车订单表生成一条订单，填充order_time接单时间及其左边的字段，start_time-开始计费的上车时间，及其右边的字段全部为null，
-- #    并把order_id订单号和order_time接单时间（end_time-打车结束时间）写入打车记录表；若一只无司机接单，超时或中途用户主动取消打车，则记录end_time打车结束时间。
-- # 3. 若乘客上车前，乘客或司机点击取消订单，会将打车订单表对应订单的finish_time订单完成时间填充为取消时间，其余字段设为null。
-- # 4. 当司机接上乘客时，填充订单表中该start_time开始计费的上车时间
-- # 5. 当订单完成时填充订单完成时间、里程数、费用；评分设为null，在用户给司机打1-5星好评后填充。

-- SQL
DROP TABLE IF EXISTS tb_get_car_record,tb_get_car_order;
CREATE TABLE tb_get_car_record
(
    id         INT PRIMARY KEY AUTO_INCREMENT COMMENT '自增ID',
    uid        INT         NOT NULL COMMENT '用户ID',
    city       VARCHAR(10) NOT NULL COMMENT '城市',
    event_time datetime COMMENT '打车时间',
    end_time   datetime COMMENT '打车结束时间',
    order_id   INT COMMENT '订单号'
) CHARACTER SET utf8
  COLLATE utf8_bin;

CREATE TABLE tb_get_car_order
(
    id          INT PRIMARY KEY AUTO_INCREMENT COMMENT '自增ID',
    order_id    INT NOT NULL COMMENT '订单号',
    uid         INT NOT NULL COMMENT '用户ID',
    driver_id   INT NOT NULL COMMENT '司机ID',
    order_time  datetime COMMENT '接单时间',
    start_time  datetime COMMENT '开始计费的上车时间',
    finish_time datetime COMMENT '订单结束时间',
    mileage     FLOAT COMMENT '行驶里程数',
    fare        FLOAT COMMENT '费用',
    grade       TINYINT COMMENT '评分'
) CHARACTER SET utf8
  COLLATE utf8_bin;

INSERT INTO tb_get_car_record(uid, city, event_time, end_time, order_id)
VALUES (101, '北京', '2021-10-01 07:00:00', '2021-10-01 07:02:00', null),
       (102, '北京', '2021-10-01 09:00:30', '2021-10-01 09:01:00', 9001),
       (101, '北京', '2021-10-01 08:28:10', '2021-10-01 08:30:00', 9002),
       (103, '北京', '2021-10-02 07:59:00', '2021-10-02 08:01:00', 9003),
       (104, '北京', '2021-10-03 07:59:20', '2021-10-03 08:01:00', 9004),
       (105, '北京', '2021-10-01 08:00:00', '2021-10-01 08:02:10', 9005),
       (106, '北京', '2021-10-01 17:58:00', '2021-10-01 18:01:00', 9006),
       (107, '北京', '2021-10-02 11:00:00', '2021-10-02 11:01:00', 9007),
       (108, '北京', '2021-10-02 21:00:00', '2021-10-02 21:01:00', 9008),
       (109, '北京', '2021-10-08 18:00:00', '2021-10-08 18:01:00', 9009);

INSERT INTO tb_get_car_order(order_id, uid, driver_id, order_time, start_time, finish_time, mileage, fare, grade)
VALUES (9002, 101, 202, '2021-10-01 08:30:00', null, '2021-10-01 08:31:00', null, null, null),
       (9001, 102, 202, '2021-10-01 09:01:00', '2021-10-01 09:06:00', '2021-10-01 09:31:00', 10.0, 41.5, 5),
       (9003, 103, 202, '2021-10-02 08:01:00', '2021-10-02 08:15:00', '2021-10-02 08:31:00', 11.0, 41.5, 4),
       (9004, 104, 202, '2021-10-03 08:01:00', '2021-10-03 08:13:00', '2021-10-03 08:31:00', 7.5, 22, 4),
       (9005, 105, 203, '2021-10-01 08:02:10', null, '2021-10-01 08:31:00', null, null, null),
       (9006, 106, 203, '2021-10-01 18:01:00', '2021-10-01 18:09:00', '2021-10-01 18:31:00', 8.0, 25.5, 5),
       (9007, 107, 203, '2021-10-02 11:01:00', '2021-10-02 11:07:00', '2021-10-02 11:31:00', 9.9, 30, 5),
       (9008, 108, 203, '2021-10-02 21:01:00', '2021-10-02 21:10:00', '2021-10-02 21:31:00', 13.2, 38, 4),
       (9009, 109, 203, '2021-10-08 18:01:00', '2021-10-08 18:11:50', '2021-10-08 18:51:00', 13, 40, 5);


# select te.city, tr.driver_id, AVG(grade) as avg_order_num, avg(mileage) avg_mileage
# from tb_get_car_order tr
#          left join tb_get_car_record te on tr.uid=te.uid
# group by city;