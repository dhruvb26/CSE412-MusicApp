import type { Metadata } from "next";
import { Inter } from "next/font/google";
import { ThemeProvider } from "@/components/theme-provider";
import "@/styles/globals.css";

const inter = Inter({
  subsets: ["latin"],
  variable: "--font-inter",
});

export const metadata: Metadata = {
  title: "MusicApp",
  description: "Browse artists, albums, songs, and reviews",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" suppressHydrationWarning>
      <body className={`${inter.variable} antialiased`}>
        <ThemeProvider attribute="class" defaultTheme="system" enableSystem>
          <div className="max-w-6xl mx-auto px-4 py-6">
            <header className="flex items-center justify-between mb-4">
              <div className="flex flex-col gap-1 font-medium">
                <h1 className="text-sm tracking-tight">MusicApp</h1>
                <p className="text-sm text-muted-foreground">
                  Dhruv Bansal, Marlow Odeh, &amp; Austin Kearsley
                </p>
              </div>
            </header>
            <main>{children}</main>
          </div>
        </ThemeProvider>
      </body>
    </html>
  );
}
