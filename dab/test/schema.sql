CREATE TABLE "userinfo" ("id" INTEGER NOT NULL PRIMARY KEY, "name" VARCHAR(255) NOT NULL, "password" VARCHAR(255) NOT NULL, "ssalt" VARCHAR(255) NOT NULL, "status" INTEGER, "usertype" INTEGER, "is_admin" INTEGER NOT NULL);
CREATE UNIQUE INDEX "userinfo_name" ON "userinfo" ("name");
CREATE TABLE "targetinfo" ("name" VARCHAR(255) NOT NULL PRIMARY KEY, "suite" VARCHAR(32) NOT NULL, "codename" VARCHAR(32) NOT NULL, "architectures" VARCHAR(255), "workdir" VARCHAR(255), "description" VARCHAR(255));
CREATE UNIQUE INDEX "targetinfo_codename" ON "targetinfo" ("codename");
CREATE TABLE "pkginfo" ("id" INTEGER NOT NULL PRIMARY KEY, "name" VARCHAR(255) NOT NULL, "target_name" VARCHAR(255) NOT NULL, "enabled" INTEGER NOT NULL, FOREIGN KEY ("target_name") REFERENCES "targetinfo" ("name"));
CREATE INDEX "pkginfo_target_name" ON "pkginfo" ("target_name");
CREATE TABLE "pkgdependsinfo" ("id" INTEGER NOT NULL PRIMARY KEY, "pkg_name" VARCHAR(255) NOT NULL, "dep_name" VARCHAR(255) NOT NULL, FOREIGN KEY ("pkg_name") REFERENCES "pkginfo" ("name"));
CREATE INDEX "pkgdependsinfo_pkg_name" ON "pkgdependsinfo" ("pkg_name");
CREATE TABLE "dscinfo" ("id" INTEGER NOT NULL PRIMARY KEY, "target_name" VARCHAR(255) NOT NULL, "package_name" VARCHAR(255) NOT NULL, "name" VARCHAR(255) NOT NULL, "version" VARCHAR(255) NOT NULL, "epoch" INTEGER, "dsc_file" VARCHAR(255) NOT NULL, "sha1sum" VARCHAR(255), "md5sum" VARCHAR(64), "filesize" INTEGER, "description" VARCHAR(255), FOREIGN KEY ("target_name") REFERENCES "targetinfo" ("name"), FOREIGN KEY ("package_name") REFERENCES "pkginfo" ("name"));
CREATE INDEX "dscinfo_target_name" ON "dscinfo" ("target_name");
CREATE INDEX "dscinfo_package_name" ON "dscinfo" ("package_name");
CREATE TABLE "debinfo" ("id" INTEGER NOT NULL PRIMARY KEY, "target_name" VARCHAR(255) NOT NULL, "package_name" VARCHAR(255) NOT NULL, "name" VARCHAR(255) NOT NULL, "arches" VARCHAR(255) NOT NULL, "version" VARCHAR(255) NOT NULL, "epoch" INTEGER, "chs_file" VARCHAR(255) NOT NULL, "sha1sum" VARCHAR(128), "md5sum" VARCHAR(64), "filesize" INTEGER, "description" VARCHAR(255), FOREIGN KEY ("target_name") REFERENCES "targetinfo" ("name"), FOREIGN KEY ("package_name") REFERENCES "pkginfo" ("name"));
CREATE INDEX "debinfo_target_name" ON "debinfo" ("target_name");
CREATE INDEX "debinfo_package_name" ON "debinfo" ("package_name");
CREATE UNIQUE INDEX "debinfo_name" ON "debinfo" ("name");
CREATE TABLE "hostinfo" ("name" VARCHAR(255) NOT NULL PRIMARY KEY, "user_id" INTEGER NOT NULL, "user_name" VARCHAR(255) NOT NULL, "arches" VARCHAR(255) NOT NULL, "capacity" INTEGER, "description" VARCHAR(255), "comment" VARCHAR(255), "ready" INTEGER NOT NULL, "enabled" INTEGER NOT NULL, FOREIGN KEY ("user_id") REFERENCES "userinfo" ("id"));
CREATE INDEX "hostinfo_user_id" ON "hostinfo" ("user_id");
CREATE TABLE "channelinfo" ("name" VARCHAR(255) NOT NULL PRIMARY KEY, "host_name" VARCHAR(255) NOT NULL, "target_name" VARCHAR(255) NOT NULL, "arches" VARCHAR(255) NOT NULL, "enabled" INTEGER NOT NULL, "max_job" INTEGER NOT NULL, "curr_job" INTEGER NOT NULL, FOREIGN KEY ("host_name") REFERENCES "hostinfo" ("name"), FOREIGN KEY ("target_name") REFERENCES "targetinfo" ("name"));
CREATE INDEX "channelinfo_host_name" ON "channelinfo" ("host_name");
CREATE INDEX "channelinfo_target_name" ON "channelinfo" ("target_name");
CREATE TABLE "taskinfo" ("id" INTEGER NOT NULL PRIMARY KEY, "state" INTEGER NOT NULL, "create_time" DATETIME NOT NULL, "start_time" DATETIME, "completion_time" DATETIME, "channel_name" VARCHAR(255), "hosts_name" VARCHAR(255), "src_id" INTEGER, "src_name" VARCHAR(255), "build_id_id" INTEGER, "build_name" VARCHAR(255), "parent" INTEGER, "label" VARCHAR(255), "waiting" INTEGER, "awaited" INTEGER, "ower_id" INTEGER, "ower_name" VARCHAR(255), "arch" VARCHAR(32) NOT NULL, "priority" INTEGER NOT NULL, FOREIGN KEY ("channel_name") REFERENCES "channelinfo" ("name"), FOREIGN KEY ("hosts_name") REFERENCES "hostinfo" ("name"), FOREIGN KEY ("src_id") REFERENCES "dscinfo" ("id"), FOREIGN KEY ("src_name") REFERENCES "dscinfo" ("name"), FOREIGN KEY ("build_id_id") REFERENCES "debinfo" ("id"), FOREIGN KEY ("build_name") REFERENCES "debinfo" ("name"), FOREIGN KEY ("ower_id") REFERENCES "userinfo" ("id"), FOREIGN KEY ("ower_name") REFERENCES "userinfo" ("name"));
CREATE INDEX "taskinfo_channel_name" ON "taskinfo" ("channel_name");
CREATE INDEX "taskinfo_hosts_name" ON "taskinfo" ("hosts_name");
CREATE INDEX "taskinfo_src_id" ON "taskinfo" ("src_id");
CREATE INDEX "taskinfo_src_name" ON "taskinfo" ("src_name");
CREATE INDEX "taskinfo_build_id_id" ON "taskinfo" ("build_id_id");
CREATE INDEX "taskinfo_build_name" ON "taskinfo" ("build_name");
CREATE INDEX "taskinfo_ower_id" ON "taskinfo" ("ower_id");
CREATE INDEX "taskinfo_ower_name" ON "taskinfo" ("ower_name");
CREATE TABLE "repoctl" ("name" VARCHAR(255) NOT NULL PRIMARY KEY, "package_name" VARCHAR(255) NOT NULL, "version" VARCHAR(255) NOT NULL, FOREIGN KEY ("package_name") REFERENCES "pkginfo" ("name"));
CREATE INDEX "repoctl_package_name" ON "repoctl" ("package_name");
CREATE TABLE "repoinfo" ("id" INTEGER NOT NULL PRIMARY KEY, "repctl_name" VARCHAR(255) NOT NULL, "repoctl_name" VARCHAR(255) NOT NULL, "update_time" DATETIME NOT NULL, "repo_config" VARCHAR(255) NOT NULL, "enabled" INTEGER NOT NULL, FOREIGN KEY ("repctl_name") REFERENCES "repoctl" ("name"));
CREATE INDEX "repoinfo_repctl_name" ON "repoinfo" ("repctl_name");