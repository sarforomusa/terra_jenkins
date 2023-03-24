

resource "aws_vpc" "Tenacity-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  tags = {
    Name = "Tenacity-vpc"
  }
}

resource "aws_subnet" "Prod-public-sub1" {

  vpc_id            = aws_vpc.Tenacity-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "Prod-pub-sub1"
  }
}

resource "aws_subnet" "prod-public-sub2" {
  vpc_id            = aws_vpc.Tenacity-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-2a"
  tags = {
    Name = "prod-pub-sub2"
  }
}

resource "aws_subnet" "Prod-private-sub1" {
  vpc_id            = aws_vpc.Tenacity-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "eu-west-2b"
  tags = {
    Name = "Prod-priv-sub1"
  }
}

resource "aws_subnet" "prod-private-sub2" {
  vpc_id            = aws_vpc.Tenacity-vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "eu-west-2c"
  tags = {
    Name = "prod-priv-sub2"
  }
}

#creating public route table
resource "aws_route_table" "prod-public-route-table" {
  vpc_id = aws_vpc.Tenacity-vpc.id

  tags = {
    cidr_block = "0.0.0.0/0"
    Name       = "Prod-pub-route-table"
  }
}

#creating private route table
resource "aws_route_table" "Prod-pri-route-table" {
  vpc_id = aws_vpc.Tenacity-vpc.id

  tags = {
    Name = "Prod-pri-route-table"
  }
}

#create internet Gateway
resource "aws_internet_gateway" "Prod-igw" {
  vpc_id = aws_vpc.Tenacity-vpc.id

  tags = {
    Name = "Prod-igw"
  }
}

#creating aws route table association
resource "aws_route_table_association" "Prod-igw-association" {
  subnet_id      = aws_subnet.prod-private-sub2.id
  route_table_id = aws_route_table.Prod-pri-route-table.id
}

resource "aws_eip" "Tenacity-IP" {
  vpc      = true
}


#NAT Gateway
resource "aws_nat_gateway" "prod-Nat-Gateway" {
  allocation_id = aws_eip.Tenacity-IP.id
  subnet_id = aws_subnet.prod-private-sub2.id

  /* tags = {
    Name = Prod-Nat-gateway
  } */

}