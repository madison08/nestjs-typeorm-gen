#!/opt/homebrew/bin/bash


# Function to create a NestJS module and CRUD
generate_module_and_crud() {
    local module_name=$1

    # Create the module
    nest g module $module_name

    # Create the controller
    nest g controller $module_name

    # Create the service
    nest g service $module_name

    # Create the directory for the entity if it doesn't exist
    mkdir -p src/$module_name/entity

    # Create the entity with id and createdAt fields
    # touch src/$module_name/entity/$module_name.entity.ts
    cat <<EOL > src/$module_name/entity/$module_name.entity.ts
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity()
export class ${module_name^} {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    name: string;


    @CreateDateColumn()
    createdAt: Date;
}
EOL

 # Create the directory for the DTOs if it doesn't exist
    mkdir -p src/$module_name/dto

    # Create the DTOs
    cat <<EOL > src/$module_name/dto/create-${module_name}.dto.ts
import { IsString } from 'class-validator';
export class Create${module_name:u}Dto {

    @IsString()
    name: string;
}
EOL

    cat <<EOL > src/$module_name/dto/update-${module_name}.dto.ts
import { PartialType } from '@nestjs/swagger';
import { Create${module_name:u}Dto } from './create-${module_name}.dto';

export class Update${module_name:u}Dto extends PartialType(Create${module_name:u}Dto) {
    // Add your properties here

}
EOL

# Add CRUD methods to the service
    cat <<EOL > src/$module_name/$module_name.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { ${module_name^} } from './entity/${module_name}.entity';
import { Create${module_name:u}Dto } from './dto/create-${module_name}.dto';
import { Update${module_name:u}Dto } from './dto/update-${module_name}.dto';

@Injectable()
export class ${module_name^}Service {
    constructor(
        @InjectRepository(${module_name^})
        private readonly ${module_name}Repository: Repository<${module_name^}>,
    ) {}

    async create(create${module_name:u}Dto: Create${module_name:u}Dto): Promise<${module_name^}> {
        const ${module_name} = this.${module_name}Repository.create(create${module_name:u}Dto);
        return this.${module_name}Repository.save(${module_name});
    }

    async findAll(): Promise<${module_name^}[]> {
        return this.${module_name}Repository.find();
    }

    async findOne(id: number): Promise<${module_name^}> {
        return this.${module_name}Repository.findOne({where: { id }});
    }

    async update(id: number, update${module_name:u}Dto: Update${module_name:u}Dto): Promise<${module_name^}> {
        await this.${module_name}Repository.update(id, update${module_name:u}Dto);
        return this.findOne(id);
    }

    async remove(id: number): Promise<void> {
        await this.${module_name}Repository.delete(id);
    }
}
EOL


    # Add CRUD methods to the controller
    cat <<EOL > src/$module_name/$module_name.controller.ts
import { Controller, Get, Post, Body, Patch, Param, Delete } from '@nestjs/common';
import { ${module_name^}Service } from './$module_name.service';
import { Create${module_name^}Dto } from './dto/create-${module_name}.dto';
import { Update${module_name^}Dto } from './dto/update-${module_name}.dto';

@Controller('$module_name')
export class ${module_name^}Controller {
    constructor(private readonly ${module_name^}Service: ${module_name^}Service) {}

    @Post()
    create(@Body() create${module_name^}Dto: Create${module_name^}Dto) {
        return this.${module_name^}Service.create(create${module_name^}Dto);
    }

    @Get()
    findAll() {
        return this.${module_name^}Service.findAll();
    }

    @Get(':id')
    findOne(@Param('id') id: string) {
        return this.${module_name^}Service.findOne(+id);
    }

    @Patch(':id')
    update(@Param('id') id: string, @Body() update${module_name^}Dto: Update${module_name^}Dto) {
        return this.${module_name^}Service.update(+id, update${module_name^}Dto);
    }

    @Delete(':id')
    remove(@Param('id') id: string) {
        return this.${module_name^}Service.remove(+id);
    }
}
EOL

# Update the module file to include TypeOrmModule.forFeature
    cat <<EOL > src/$module_name/$module_name.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ${module_name^}Controller } from './$module_name.controller';
import { ${module_name^}Service } from './$module_name.service';
import { ${module_name^} } from './entity/${module_name}.entity';

@Module({
  imports: [TypeOrmModule.forFeature([${module_name^}])],
  controllers: [${module_name^}Controller],
  providers: [${module_name^}Service],
})
export class ${module_name^}Module {}
EOL

    echo "Module $module_name created successfully!"
}

# Check if a module name is provided
if [ $# -eq 0 ]; then
    echo "Please provide a module name."
    exit 1
fi

# Generate the module and CRUD
for module_name in "$@"; do
    generate_module_and_crud $module_name
done