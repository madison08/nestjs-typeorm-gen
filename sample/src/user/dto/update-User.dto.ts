import { PartialType } from '@nestjs/swagger';
import { CreateUserDto } from './create-User.dto';

export class UpdateUserDto extends PartialType(CreateUserDto) {
    // Add your properties here

}
