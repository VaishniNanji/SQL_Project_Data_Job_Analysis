CREATE TABLE data_science_jobs (
    job_id INT,
    job_title TEXT,
    company_name TEXT,
    post_date DATE
);

ALTER TABLE data_science_jobs
ADD PRIMARY KEY (job_id);

INSERT INTO data_science_jobs (
    job_id,
    job_title,
    company_name,
    post_date)
VALUES 
    (1,
    'Data Scientist',
    'Tech Innovations',
    'January 1, 2023'),
    (2, 
    'Machine Learning Engineer',
    'Data Driven Co',
    'January 15, 2023'),
    (3,
    'AI Specialist',
    'Future Tech',
    'February 1, 2023'
);

ALTER TABLE data_science_jobs
ADD remote BOOLEAN;

ALTER TABLE data_science_jobs
RENAME COLUMN post_date TO posted_on;

ALTER TABLE data_science_jobs
ALTER COLUMN remote 
SET DEFAULT FALSE;

INSERT INTO data_science_jobs (job_id, job_title, company_name, posted_on)
VALUES (4, 'Data Scientist', ' Google', 'February 5, 2023');

SELECT * FROM data_science_jobs;

ALTER TABLE data_science_jobs
DROP COLUMN company_name;

UPDATE data_science_jobs
SET remote = TRUE
WHERE job_id = 2;

DROP TABLE data_science_jobs;