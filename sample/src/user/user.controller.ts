import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { UserService } from './User.service';
import { CreateUserDto } from './dto/create-User.dto';
import { UpdateUserDto } from './dto/update-User.dto';

@Controller('User')
export class UserController {
    constructor(private readonly UserService: UserService) {}

    @Post()
    create(@Body() createUserDto: CreateUserDto) {
        return this.UserService.create(createUserDto);
    }

    @Get()
    findAll() {
        return this.UserService.findAll();
    }

    @Get(':id')
    findOne(@Param('id') id: string) {
        return this.UserService.findOne(+id);
    }

    @Patch(':id')
    update(@Param('id') id: string, @Body() updateUserDto: UpdateUserDto) {
        return this.UserService.update(+id, updateUserDto);
    }

    @Delete(':id')
    remove(@Param('id') id: string) {
        return this.UserService.remove(+id);
    }
}
