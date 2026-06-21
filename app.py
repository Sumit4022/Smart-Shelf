import mysql.connector

conn = mysql.connector.connect(
    host="localhost",
    user="root",
    password="root",
    database="SmartShelfDB"
)

cursor = conn.cursor()

def issue_book():
    try:
        m = int(input("Enter Member ID: "))
        b = int(input("Enter Book ID: "))
        l = int(input("Enter Librarian ID: "))

        cursor.execute("""
        INSERT INTO book_info
        (Borrow_Date, Borrow_Time, Due_Date, Status, Librarian_Id, Member_Id, Book_Id)
        VALUES (CURDATE(), CURTIME(), DATE_ADD(CURDATE(), INTERVAL 14 DAY),
                'Issued', %s, %s, %s)
        """, (l, m, b))

        conn.commit()
        print("✅ Book Issued Successfully!")

    except mysql.connector.Error as err:
        print("❌ Error:", err)


def return_book():
    try:
        bid = int(input("Enter Borrow ID: "))

        cursor.execute("""
        UPDATE book_info 
        SET Status='Returned' 
        WHERE Borrow_Id=%s
        """, (bid,))

        conn.commit()
        print("✅ Book Returned Successfully!")

    except mysql.connector.Error as err:
        print("❌ Error:", err)


def view_books():
    cursor.execute("SELECT Book_Id, Title, Author, Quantity FROM book")

    print("\n📚 --- BOOK LIST ---")
    for row in cursor.fetchall():
        print(row)


def member_history():
    try:
        mid = int(input("Enter Member ID: "))

        cursor.execute("""
        SELECT b.Title, bi.Borrow_Date, bi.Status
        FROM book_info bi
        JOIN book b ON bi.Book_Id = b.Book_Id
        WHERE bi.Member_Id = %s
        """, (mid,))

        print("\n👤 --- BORROW HISTORY ---")
        for row in cursor.fetchall():
            print(row)

    except:
        print("❌ Invalid Input")


def view_fines():
    cursor.execute("""
    SELECT f.Fine_Id, f.Amount, m.Name
    FROM fine f
    JOIN book_info bi ON f.Borrow_Id = bi.Borrow_Id
    JOIN member m ON bi.Member_Id = m.Member_Id
    WHERE f.Paid_Status = 'Unpaid'
    """)

    print("\n💰 --- UNPAID FINES ---")
    for row in cursor.fetchall():
        print(row)


def search_book():
    title = input("Enter book title keyword: ")

    cursor.execute("""
    SELECT Book_Id, Title, Author, Quantity
    FROM book
    WHERE Title LIKE %s
    """, ('%' + title + '%',))

    print("\n🔍 --- SEARCH RESULTS ---")
    for row in cursor.fetchall():
        print(row)


while True:
    print("\n====== 📘 SMARTSHELF MENU ======")
    print("1. Issue Book")
    print("2. Return Book")
    print("3. View All Books")
    print("4. Member Borrow History")
    print("5. View Unpaid Fines")
    print("6. Search Book")
    print("7. Exit")

    choice = input("Enter your choice: ")

    if choice == '1':
        issue_book()

    elif choice == '2':
        return_book()

    elif choice == '3':
        view_books()

    elif choice == '4':
        member_history()

    elif choice == '5':
        view_fines()

    elif choice == '6':
        search_book()

    elif choice == '7':
        print("👋 Exiting program...")
        break

    else:
        print("❌ Invalid choice, try again!")