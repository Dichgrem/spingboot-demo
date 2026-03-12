package com.stu.helloserver.controller;

import com.stu.helloserver.common.Result;
import com.stu.helloserver.entity.User;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @GetMapping("/{id}")
    public Result<String> getUser(@PathVariable("id") Long id) {
        return Result.success("查询成功，正在返回 ID 为 " + id + " 的用户信息");
    }

    @PostMapping
    public Result<String> createUser(@RequestBody User user) {
        return Result.success("新增成功，接收到用户：" + user.getName() + "，年龄：" + user.getAge());
    }

    @PutMapping("/{id}")
    public Result<String> updateUser(@PathVariable("id") Long id, @RequestBody User user) {
        return Result.success("更新成功，ID " + id + " 的用户已修改为：" + user.getName());
    }

    @DeleteMapping("/{id}")
    public Result<String> deleteUser(@PathVariable("id") Long id) {
        return Result.success("删除成功，已移除 ID 为 " + id + " 的用户");
    }

    @GetMapping("/error")
    public Result<String> testError() {
        int a = 1 / 0;
        return Result.success("test");
    }
}
