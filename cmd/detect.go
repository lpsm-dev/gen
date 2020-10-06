package cmd

import (
	"bytes"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"

	"github.com/go-enry/go-enry/v2"
	"github.com/spf13/cobra"
)

// default flag to show all files, including those identifed as non-programming languages.
var all = false

func createDetectCmd() *cobra.Command {
	cmd := &cobra.Command{
		Use:   "detect",
		Short: "Detects the programming language used in your project",
		RunE: func(cmd *cobra.Command, args []string) error {
			var err error
			out := make(map[string][]string, 0)
			final := make(map[string]int)

			fmt.Printf("Programming language detector\n\n")

			rootDir, err := os.Getwd()
			if err != nil {
				return err
			}

			err = filepath.Walk(rootDir, func(path string, f os.FileInfo, err error) error {
				if err != nil {
					return filepath.SkipDir
				}

				if !f.Mode().IsDir() && !f.Mode().IsRegular() {
					return nil
				}

				relativePath, err := filepath.Rel(rootDir, path)
				if err != nil {
					log.Println(err)
					return nil
				}

				if relativePath == "." {
					return nil
				}

				if f.IsDir() {
					relativePath = relativePath + "/"
				}

				if enry.IsVendor(relativePath) ||
					enry.IsDotFile(relativePath) ||
					enry.IsDocumentation(relativePath) ||
					enry.IsConfiguration(relativePath) {
					if f.IsDir() {
						return filepath.SkipDir
					}
					return nil
				}

				if f.IsDir() {
					return nil
				}

				content, err := readFile(path, 16*1024)
				if err != nil {
					return nil
				}

				language := enry.GetLanguage(filepath.Base(path), content)
				if language == enry.OtherLanguage {
					return nil
				}

				if !all &&
					enry.GetLanguageType(language) != enry.Programming &&
					enry.GetLanguageType(language) != enry.Markup {
					return nil
				}

				out[language] = append(out[language], relativePath)
				return nil
			})

			if err != nil {
				log.Fatal(err)
			}

			total := 0.0
			for fType, file := range out {
				size := len(file)
				final[fType] = size
				total += float64(size)
			}

			fmt.Println(final)
			fmt.Println(total)

			return err
		},
	}
	cmd.PersistentFlags().BoolVarP(&all, "all", "a", false, "show all files, including those identifed as non-programming languages")
	return cmd
}

func readFile(path string, limit int64) ([]byte, error) {
	if limit <= 0 {
		return ioutil.ReadFile(path)
	}
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer f.Close()
	st, err := f.Stat()
	if err != nil {
		return nil, err
	}
	size := st.Size()
	if limit > 0 && size > limit {
		size = limit
	}
	buf := bytes.NewBuffer(nil)
	buf.Grow(int(size))
	_, err = io.Copy(buf, io.LimitReader(f, limit))
	return buf.Bytes(), err
}
