DROP DATABASE IF EXISTS citrus;
CREATE DATABASE IF NOT EXISTS citrus DEFAULT CHARSET utf8 COLLATE utf8_general_ci;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

use citrus;

-- ------------用户表----------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`
(
  `user_id`            bigint NOT NULL COMMENT '主键id',
  `login_id`           varchar(45) DEFAULT NULL COMMENT '登录Id',
  `password`           varchar(100) DEFAULT NULL COMMENT '密码',
  `username`           varchar(45) DEFAULT NULL COMMENT '名字',
  `email`              varchar(45) DEFAULT NULL COMMENT '电子邮件',
  `mobile`             varchar(45) DEFAULT NULL COMMENT '手机',
  `uuid`               varchar(45) DEFAULT NULL COMMENT 'UUID',
  `admin`              int(1)      DEFAULT 0 COMMENT '是否管理员',
  `avatar`             mediumtext  DEFAULT NULL COMMENT '头像',
  `status`             bigint      DEFAULT NULL COMMENT '状态',
  `created_time`        datetime    DEFAULT NULL COMMENT '创建时间',
  `created_by`          bigint  DEFAULT NULL COMMENT '创建人',
  `last_modified_time` datetime    DEFAULT NULL COMMENT '最后的更新时间',
  `last_modified_by`   bigint  DEFAULT NULL COMMENT '最后的更新人',
  `version`            int(11)     DEFAULT 0 COMMENT '乐观锁',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  ROW_FORMAT = DYNAMIC COMMENT ='用户表';

create index IX_SYS_USER_LOGINID on sys_user (login_id);
create index IX_SYS_USER_USERNAME on sys_user (username);
create index IX_SYS_USER_UUID on sys_user (uuid);
create index IX_SYS_USER_MOBILE on sys_user (mobile);

-- ----------------------------

-- ------------角色表----------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`
(
  `role_id`            bigint NOT NULL COMMENT '主键id',
  `parent_id`          bigint  DEFAULT NULL COMMENT '父角色ID',
  `type`               int        NOT NULL COMMENT '类型 0：角色 1：角色组',
  `role_name`          varchar(45) DEFAULT NULL COMMENT '名字',
  `created_time`        datetime    DEFAULT NULL COMMENT '创建时间',
  `created_by`          bigint  DEFAULT NULL COMMENT '创建人',
  `last_modified_time` datetime    DEFAULT NULL COMMENT '最后的更新时间',
  `last_modified_by`   bigint  DEFAULT NULL COMMENT '最后的更新人',
  `order_id`           int         DEFAULT NULL COMMENT '排序标识',
  `admin`              int         DEFAULT 0 COMMENT '是否超管',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  ROW_FORMAT = DYNAMIC COMMENT ='角色表';

create index IX_SYS_ROLE_ROLENAME on sys_role (role_name);
-- ----------------------------

-- ------------资源表----------------
DROP TABLE IF EXISTS `sys_resource`;
CREATE TABLE `sys_resource`
(
  `resource_id`        bigint NOT NULL COMMENT '主键id',
  `resource_name`      varchar(50)   DEFAULT NULL COMMENT '资源名称名字',
  `component`          varchar(1000) DEFAULT NULL COMMENT '前端组件路径',
  `icon`               varchar(500)  DEFAULT NULL COMMENT '资源菜单图标（mdi）',
  `parent_id`          varchar(500)  DEFAULT NULL COMMENT '父ID',
  `type`               int          NOT NULL COMMENT '资源类型',
  `path`               varchar(2000) DEFAULT NULL COMMENT '资源路径',
  `operation`          varchar(100)  DEFAULT NULL COMMENT '操作类型',
  `resource_code`      varchar(100)  DEFAULT NULL COMMENT '资源代码',
  `created_time`        datetime      DEFAULT NULL COMMENT '创建时间',
  `created_by`          bigint    DEFAULT NULL COMMENT '创建人',
  `last_modified_time` datetime      DEFAULT NULL COMMENT '最后的更新时间',
  `last_modified_by`   bigint    DEFAULT NULL COMMENT '最后的更新人',
  `hidden`             int           DEFAULT 0 COMMENT '是否隐藏',
  PRIMARY KEY (`resource_id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  ROW_FORMAT = DYNAMIC COMMENT ='资源表';

create index IX_SYS_RESOURCE_RESOURCENAME on sys_resource (resource_name);
-- ----------------------------

-- ------------组织机构表----------------
DROP TABLE IF EXISTS `sys_organ`;
CREATE TABLE `sys_organ`
(
  `organ_id`           bigint AUTO_INCREMENT NOT NULL COMMENT '主键id',
  `organ_name`         varchar(250)              NOT NULL COMMENT '资源名字',
  `organ_code`         varchar(50)               NOT NULL COMMENT '组织机构代码',
  `deep`               int                       NOT NULL COMMENT '树的深度',
  `parent_id`          bigint                NOT NULL NULL COMMENT '父ID',
  `left_value`         int(7)                    NOT NULL COMMENT '左值',
  `right_value`        int(7)                    NOT NULL COMMENT '右值',
  `created_time`       datetime      DEFAULT NULL COMMENT '创建时间',
  `created_by`         bigint    DEFAULT NULL COMMENT '创建人',
  `last_modified_time` datetime      DEFAULT NULL COMMENT '最后的更新时间',
  `last_modified_by`   bigint    DEFAULT NULL COMMENT '最后的更新人',
  `remark`             varchar(1000) DEFAULT NULL COMMENT '最后的更新人',
  PRIMARY KEY (`organ_id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  ROW_FORMAT = DYNAMIC COMMENT ='组织机构表';

create index IX_SYS_ORGAN_ORGANNAME on sys_organ (organ_name);
create index IX_SYS_ORGAN_LEFTVALUE on sys_organ (left_value);
create index IX_SYS_ORGAN_RIGHTVALUE on sys_organ (right_value);
-- ----------------------------

-- ------------数据范围表----------------
DROP TABLE IF EXISTS `sys_scope`;
CREATE TABLE `sys_scope`
(
  `scope_id`   bigint   NOT NULL COMMENT '数据范围ID',
  `scope_name` varchar(500) NOT NULL COMMENT '范围名称',
  `organ_id`   bigint   NOT NULL COMMENT '组织ID',
  PRIMARY KEY (`scope_id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  ROW_FORMAT = DYNAMIC COMMENT ='数据范围表';

-- ----------------------------

-- ------------数据范围定义表----------------
DROP TABLE IF EXISTS `sys_scope_define`;
CREATE TABLE `sys_scope_define`
(
  `id`          bigint NOT NULL COMMENT '数据范围定义对象ID',
  `scope_id`    bigint NOT NULL COMMENT '关联的数据范围ID',
  `organ_id`    bigint NOT NULL COMMENT '组织ID',
  `scope_rule`  int        not null COMMENT '数据范围的规则（0：包含，1：排除）',
  `scope_types` varchar(20) COMMENT '范围类型（自身、包含子部门、包含父部门）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  ROW_FORMAT = DYNAMIC COMMENT ='数据范围定义表';

-- ----------------------------

-- ------------权限表----------------
DROP TABLE IF EXISTS `sys_authority`;
CREATE TABLE `sys_authority`
(
  `authority_id`       bigint NOT NULL COMMENT '主键id',
  `authority_name`     varchar(50)   DEFAULT NULL COMMENT '权限名字',
  `remark`             varchar(2000) DEFAULT NULL COMMENT '权限名字',
  `created_time`        datetime      DEFAULT NULL COMMENT '创建时间',
  `created_by`          bigint    DEFAULT NULL COMMENT '创建人',
  `last_modified_time` datetime      DEFAULT NULL COMMENT '最后的更新时间',
  `last_modified_by`   bigint    DEFAULT NULL COMMENT '最后的更新人',
  PRIMARY KEY (`authority_id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  ROW_FORMAT = DYNAMIC COMMENT ='权限表';

create index IX_SYS_AUTHORITY_AUTHORITYNAME on sys_authority (authority_name);
-- ----------------------------


-- ------------权限资源关系表----------------
DROP TABLE IF EXISTS `sys_auth_resource`;
CREATE TABLE `sys_auth_resource`
(

  `authority_id` bigint NOT NULL COMMENT '权限ID',
  `resource_id`  bigint NOT NULL COMMENT '资源ID',
  `scope_id`     bigint COMMENT '数据范围ID',
  `object_id`    bigint COMMENT '关联的对象，如果资源类型为"操作"，即关联的对象为该"操作对应的资源ID 例如 菜单与新增、删除等操作，此实体中的resourceId为操作类型的ID，即此objectId为此操作对应的菜单',
  `type`         int(2) COMMENT '资源类型，菜单为0；操作为2',
  `id`           varchar(1000) COMMENT '逻辑ID',
  PRIMARY KEY (`authority_id`, `resource_id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  ROW_FORMAT = DYNAMIC COMMENT ='权限资源关系表';

-- ----------------------------

-- ------------用户机构关系表----------------
DROP TABLE IF EXISTS `sys_user_organ`;
CREATE TABLE `sys_user_organ`
(
  `user_id`  bigint NOT NULL COMMENT '用户ID',
  `organ_id` bigint NOT NULL COMMENT '组织ID',
  `id`       varchar(1000) COMMENT '逻辑ID',
  PRIMARY KEY (`user_id`, `organ_id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  ROW_FORMAT = DYNAMIC COMMENT ='用户机构关系表';

-- ----------------------------

-- ------------用户角色关系表----------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`
(
  `user_id`  bigint NOT NULL COMMENT '用户ID',
  `role_id`  bigint NOT NULL COMMENT '角色ID',
  `organ_id` bigint NOT NULL COMMENT '组织ID',
  `id`       varchar(1000) COMMENT '逻辑ID',
  PRIMARY KEY (`user_id`, `role_id`, `organ_id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  ROW_FORMAT = DYNAMIC COMMENT ='用户角色关系表';

-- ----------------------------

-- ------------角色权限关系表----------------
DROP TABLE IF EXISTS `sys_role_auth`;
CREATE TABLE `sys_role_auth`
(
  `role_id`      bigint NOT NULL COMMENT '角色ID',
  `authority_id` bigint NOT NULL COMMENT '权限ID',
   `id`           varchar(1000) COMMENT '逻辑ID',
  PRIMARY KEY (`role_id`, `authority_id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  ROW_FORMAT = DYNAMIC COMMENT ='角色权限关系表';

-- ----------------------------


-- ------------字典目录表----------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict`
(
  `dict_id`   bigint    NOT NULL COMMENT '字典ID',
  `dict_code` varchar(200)  NOT NULL COMMENT '字典编码',
  `dict_name` varchar(1000) NOT NULL COMMENT '字典名',
  PRIMARY KEY (`dict_id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  ROW_FORMAT = DYNAMIC COMMENT ='字典目录表';

-- ----------------------------


-- ------------访问日志表----------------
DROP TABLE IF EXISTS `sys_access_log`;
CREATE TABLE `sys_access_log`
(
  `id`             bigint    NOT NULL COMMENT 'ID',
  `user_id`        bigint    DEFAULT NULL COMMENT '访问的用户ID',
  `username`       varchar(1000) NOT NULL COMMENT '访问的用户名',
  `ip_address`     varchar(1000) NOT NULL COMMENT '访问的IP地址',
  `url`            varchar(1000) NOT NULL COMMENT '访问的url',
  `request_method` varchar(50)   NOT NULL COMMENT '请求方式',
  `params`         varchar(1000) DEFAULT NULL COMMENT '请求参数，JSON串',
  `resource_id`    varchar(1000) DEFAULT NULL COMMENT '资源ID',
  `resource_name`  varchar(1000) DEFAULT NULL COMMENT '资源名',
  `resource_type`  int           DEFAULT NULL COMMENT '资源类型',
  `created_time`    datetime      NOT NULL COMMENT '访问时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  ROW_FORMAT = DYNAMIC COMMENT ='访问日志表';

-- ----------------------------


-- ------------系统文件表表----------------
DROP TABLE IF EXISTS `sys_file`;
CREATE TABLE `sys_file`
(
  `file_id`            varchar(50)   NOT NULL COMMENT '主键',
  `identify`           varchar(250)  NOT NULL COMMENT '文件标识，用于标识是否是同一文件',
  `file_no`             int           DEFAULT NULL COMMENT '文件编号',
  `filename`           varchar(2000) NOT NULL COMMENT '文件名',
  `bytes`              longblob      DEFAULT NULL COMMENT '文件的二进制',
  `path`               varchar(2000) DEFAULT NULL COMMENT '文件存储路径',
  `size`               bigint    NOT NULL COMMENT '文件大小',
  `file_type`          varchar(50)   NOT NULL COMMENT '文件类型',
  `created_time`       datetime      DEFAULT NULL COMMENT '创建时间',
  `created_by`         bigint    DEFAULT NULL COMMENT '创建人',
  `last_modified_time` datetime      DEFAULT NULL COMMENT '最后的更新时间',
  `last_modified_by`   bigint    DEFAULT NULL COMMENT '最后的更新人',
  PRIMARY KEY (`file_id`) USING BTREE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  ROW_FORMAT = DYNAMIC COMMENT ='系统文件表表';

-- ----------------------------