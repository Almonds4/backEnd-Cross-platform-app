-- Create ENUM types
DROP TYPE IF EXISTS gender_enum CASCADE;
DROP TYPE IF EXISTS account_enum CASCADE;
DROP TYPE IF EXISTS department_enum CASCADE;
DROP TYPE IF EXISTS resource_enum CASCADE;
DROP TYPE IF EXISTS transaction_status_enum CASCADE;


CREATE TYPE gender_enum AS ENUM ('Male', 'Female', 'Other');
CREATE TYPE account_enum AS ENUM ('student', 'instructor', 'tech', 'admin');
CREATE TYPE department_enum AS ENUM ('Science', 'Technology', 'Engineering', 'Math', 'Other');
CREATE TYPE resource_enum AS ENUM ('Book', 'Article', 'Research Paper', 'Video', 'E-Book');
CREATE TYPE transaction_status_enum AS ENUM ('Pending', 'Completed', 'Failed', 'Refunded');



-- dropping tables

DROP TABLE IF EXISTS "IIAEMS".mailbox;
DROP TABLE IF EXISTS "IIAEMS".discussion_forum;
DROP TABLE IF EXISTS "IIAEMS".calendar;
DROP TABLE IF EXISTS "IIAEMS".networking_hub;
DROP TABLE IF EXISTS "IIAEMS".transaction_history;
DROP TABLE IF EXISTS "IIAEMS".library;
DROP TABLE IF EXISTS "IIAEMS".grades;
DROP TABLE IF EXISTS "IIAEMS".enrollment;
DROP TABLE IF EXISTS "IIAEMS".modules;
DROP TABLE IF EXISTS "IIAEMS".instructor_courses;
DROP TABLE IF EXISTS "IIAEMS".courses;
DROP TABLE IF EXISTS "IIAEMS".users;




-- Table: IIAEMS.users

CREATE TABLE IF NOT EXISTS "IIAEMS".users
(
    username VARCHAR(255) PRIMARY KEY,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    DoB DATE,
    phone VARCHAR(20),
    gender gender_enum,
    address VARCHAR(255),
    enrollment_date_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    email VARCHAR(50),
    account_type VARCHAR(10) CHECK (account_type IN ('student', 'instructor', 'tech', 'admin')) DEFAULT 'student',
    alumni BOOLEAN DEFAULT FALSE,
    alumni_Grad DATE DEFAULT NULL
);



-- Table: IIAEMS.courses


CREATE TABLE IF NOT EXISTS "IIAEMS".courses
(
    course_id SERIAL PRIMARY KEY,
    course_name VARCHAR(255) UNIQUE NOT NULL,
    instructor_username VARCHAR(255) REFERENCES "IIAEMS".users(username) ON DELETE SET NULL,
    completion_time INTERVAL,
    description VARCHAR(255),
    price DECIMAL(5,2),
    language VARCHAR(15),
    required_material VARCHAR(255),
    meeting_times VARCHAR(255),
    department department_enum NOT NULL
);

-- Table: IIAEMS.instructor_courses junction table


CREATE TABLE IF NOT EXISTS "IIAEMS".instructor_courses
(
    username VARCHAR(255) REFERENCES "IIAEMS".users(username) ON DELETE SET NULL,
    course_id INT REFERENCES "IIAEMS".courses(course_id) ON DELETE SET NULL,
    PRIMARY KEY (username, course_id)
);


-- Table: IIAEMS.modules


CREATE TABLE IF NOT EXISTS "IIAEMS".modules
(
    course_id INT REFERENCES "IIAEMS".courses(course_id),
    module_title VARCHAR(255),
    module_description TEXT,
    module_material TEXT,
    PRIMARY KEY (course_id, module_title)
);

-- Table: IIAEMS.enrollment


CREATE TABLE IF NOT EXISTS "IIAEMS".enrollment(
    username VARCHAR(255) REFERENCES "IIAEMS".users(username) ON DELETE SET NULL,
    course_id INT REFERENCES "IIAEMS".courses(course_id) ON DELETE SET NULL,
    date_enrolled DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (username, course_id)
);

-- Table: IIAEMS.grades


CREATE TABLE IF NOT EXISTS "IIAEMS".grades
(
    username VARCHAR(255),
    course_id INT,
    module_title VARCHAR(255),
    module_grade INT CHECK (module_grade BETWEEN 0 AND 100),
    PRIMARY KEY (username, course_id, module_title),
    FOREIGN KEY (course_id, module_title) REFERENCES "IIAEMS".modules(course_id, module_title) ON DELETE SET NULL
);

-- Table: IIAEMS.library


CREATE TABLE IF NOT EXISTS "IIAEMS".library
(
    item_id SERIAL PRIMARY KEY,
    title VARCHAR(255),
    author VARCHAR(255),
    year INT CHECK (year >= 1000 AND year <= EXTRACT(YEAR FROM CURRENT_DATE)),
    resource_type resource_enum,
    file_url TEXT
);

-- Table: IIAEMS.transaction_history


CREATE TABLE IF NOT EXISTS "IIAEMS".transaction_history
(
    transaction_id SERIAL PRIMARY KEY,
    username VARCHAR(255) REFERENCES "IIAEMS".users(username) ON DELETE SET NULL,
    item VARCHAR(255),
    transaction_date_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    price DECIMAL(10,2) CHECK (Price >= 0),
    transaction_status transaction_status_enum NOT NULL
);

-- Table: IIAEMS.networking_hub


CREATE TABLE IF NOT EXISTS "IIAEMS".networking_hub
(
    username VARCHAR(255) PRIMARY KEY REFERENCES "IIAEMS".users(username) ON DELETE SET NULL,
    photo_URL TEXT,
    description TEXT,
    linkedIn TEXT CHECK (LinkedIn ~ '^https?:\/\/(www\.)?linkedin\.com\/.*$')
);

-- Table: IIAEMS.calendar


CREATE TABLE IF NOT EXISTS "IIAEMS".calendar
(
    username VARCHAR(255),
    event_date TIMESTAMP,
    description TEXT,
    PRIMARY KEY (username, event_date),
    FOREIGN KEY (username) REFERENCES "IIAEMS".users(username) ON DELETE SET NULL
);

-- Table: IIAEMS.discussion_forum


CREATE TABLE IF NOT EXISTS "IIAEMS".discussion_forum
(
    forum_id SERIAL PRIMARY KEY,
    course_id INT REFERENCES "IIAEMS".courses(course_id) ON DELETE SET NULL,
    module_title VARCHAR(255) REFERENCES "IIAEMS".modules(course_id, module_title) ON DELETE SET NULL,
    comment_username VARCHAR(255) REFERENCES "IIAEMS".users(username) ON DELETE SET NULL,
    comment_description TEXT NOT NULL,
    comment_date_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    parent_comment_id INT REFERENCES "IIAEMS".discussion_forum(forum_id) ON DELETE SET NULL
);


-- Table: IIAEMS.mailbox

CREATE TABLE IF NOT EXISTS "IIAEMS".mailbox
(
    mail_id SERIAL PRIMARY KEY,
    sender_username VARCHAR(255) REFERENCES "IIAEMS".users(username) ON DELETE SET NULL,
    recipient_username VARCHAR(255) REFERENCES "IIAEMS".users(username) ON DELETE SET NULL,
    message TEXT NOT NULL,
    sent_date_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


