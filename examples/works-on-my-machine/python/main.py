import cowsay


def greeting() -> str:
    return cowsay.get_output_string("cow", "It works on my machine!")


if __name__ == "__main__":
    print(greeting())
