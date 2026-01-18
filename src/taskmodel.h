#ifndef TASKSMODEL_H
#define TASKSMODEL_H

#include <QAbstractListModel>
#include <vector>

struct TaskItem {
    QString id;
    QString title;
    bool completed;
};

class TasksModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum TaskRoles {
        IdRole = Qt::UserRole + 1,
        TitleRole,
        CompletedRole
    };

    explicit TasksModel(QObject *parent = nullptr);

    // Core model functions
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override;
    QHash<int, QByteArray> roleNames() const override;

    // Helper to add tasks later from the Network Manager
    void setTasks(const std::vector<TaskItem> &tasks);

private:
    std::vector<TaskItem> m_tasks;
};

#endif // TASKSMODEL_H